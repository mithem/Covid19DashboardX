//
//  DataManager.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import Network
import SwiftUI
import Reachability

class DataManager: ObservableObject {
    @Published var countries: [Country]
    @Published var latestGlobal: GlobalMeasurement?
    @Published var error: NetworkError?
    @Published var loadingTasks: Set<DataTask>
    
    private var pendingTasks: Set<DataTask>
    private let reachability: Reachability
    private var _sortBy: CountrySortingCriteria
    var sortBy: CountrySortingCriteria {
        get {
            _sortBy
        }
        set {
            _sortBy = newValue
            sortCountries()
        }
    }
    private var _reversed: Bool
    var reversed: Bool {
        get {
            _reversed
        }
        set {
            _reversed = newValue
            sortCountries()
        }
    }
    
    typealias CountryDataResult = Result<Country, NetworkError>
    typealias GetCountryDataCompletionHandler = (CountryDataResult) -> Void
    
    
    // MARK: Summary data
    
    
    class func getSummary(completion: @escaping (Result<SummaryResponse, NetworkError>) -> Void) {
        APIConfig.Provider1.summary.request { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .fallbackSuccessful(_):
                completion(.failure(.cachingInProgress))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func parseSummary(_ data: Result<SummaryResponse, NetworkError>) -> Result<[Country], NetworkError> {
        switch data {
        case .success(let response):
            var tempCountries = [Country]()
            for country in response.countries {
                let measurement = country.toCountrySummaryMeasurement()
                
                let newCountry = Country(code: country.countryCode, name: country.country, latest: measurement)
                tempCountries.append(newCountry)
            }
            return .success(tempCountries)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loadSummary() {
        DispatchQueue.main.async {
            self.loadingTasks.insert(.summary)
        }
        Self.getSummary { result in
            switch Self.parseSummary(result) {
            case .success(let countries):
                self.pendingTasks.remove(.summary)
                DispatchQueue.global().async {
                    indexForSpotlight(countries: countries)
                }
                DispatchQueue.main.async {
                    self.sortCountries()
                    self.countries = countries
                    self.error = nil
                }
            case .failure(let error):
                self.handleError(error, task: .summary)
            }
            DispatchQueue.main.async {
                self.loadingTasks.remove(.summary)
            }
        }
    }
    
    
    // MARK: Global summary
    
    
    class func getGlobalSummary(completion: @escaping (Result<GlobalMeasurement, NetworkError>) -> Void) {
        APIConfig.Provider2.api.reports.total.request { result in
            completion(result.toStandardResult().map {$0.toGlobalMeasurement()})
        }
    }
    
    
    func loadGlobalSummary() {
        DispatchQueue.main.async {
            self.loadingTasks.insert(.globalSummary)
        }
        Self.getGlobalSummary { result in
            switch result {
            case .success(let globalMeasurement):
                DispatchQueue.global().async {
                    indexGlobalMeasurementForSpotlight(globalMeasurement)
                }
                DispatchQueue.main.async {
                    self.latestGlobal = globalMeasurement
                }
            case .failure(let error):
                self.handleError(error, task: .summary)
            }
            DispatchQueue.main.async {
                self.loadingTasks.remove(.globalSummary)
            }
        }
    }
    
    
    // MARK: Country history data
    
    
    class func getHistoryData(for country: Country, completion: @escaping (Result<(Country, [CountryHistoryMeasurementForDecodingOnly]), NetworkError>) -> Void) {
        APIConfig.Provider1.total.country.request(pathAppendix: "/\(country.code)") { result in
            completion(result.toStandardResult().map {(country, $0)})
        }
    }
    
    class func parseHistoryData(_ data: Result<(Country, [CountryHistoryMeasurementForDecodingOnly]), NetworkError>) -> CountryDataResult {
        switch data {
        case .success(let (country, measurements)):
            for measurement in measurements {
                country.measurements.append(measurement.toCountryHistoryMeasurement())
            }
            return .success(country)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loadHistoryData(for country: Country) {
        loadHistoryData(for: country.code)
    }
    
    func loadHistoryData(for countryCode: String) {
        DispatchQueue.main.async {
            self.loadingTasks.insert(.historyData(countryCode: countryCode))
        }
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        country.code = countryCode // is this needed? Don't wanna search all this..
        
        Self.getHistoryData(for: country) { result in
            switch Self.parseHistoryData(result) {
            case .success(let country):
                self.pendingTasks.remove(.historyData(countryCode: countryCode))
                DispatchQueue.main.async {
                    if let idx = self.countries.firstIndex(of: country) {
                        self.countries[idx] = country
                    }
                    self.error = nil
                }
            case .failure(let error):
                self.handleError(error, task: .historyData(countryCode: countryCode))
            }
            DispatchQueue.main.async {
                self.loadingTasks.remove(.historyData(countryCode: countryCode))
            }
        }
    }
    
    
    // MARK: Province data
    
    
    class func getProvinceData(for country: Country, at date: Date? = nil, completion: @escaping (Result<CountryProvincesResponse, NetworkError>) -> Void) {
        let code = Constants.alpha2_to_alpha3_countryCodes[country.code] as? String ?? country.code
        APIConfig.Provider2.api.reports.request(queryItems: [.init(name: "iso", value: code)]) { result in
            completion(result.toStandardResult())
        }
    }
    
    class func parseProvinceData(_ data: Result<CountryProvincesResponse, NetworkError>, country: Country) -> CountryDataResult {
        switch data {
        case .success(let response):
            if response.data.isEmpty {
                return .failure(.noResponse)
            } else {
                for measurement in response.data {
                    if measurement.region.iso.lowercased().starts(with: "de") {
                        print("\(measurement.region.province): \(measurement.deaths) deaths, \(measurement.deathsDiff) new")
                    }
                    if measurement.region.province != country.name && !measurement.region.province.isEmpty {
                        let newMeasurement = measurement.toProvinceMeasurement()
                        let province = Province(name: measurement.region.province, measurements: [newMeasurement])
                        country.provinces.append(province)
                    }
                }
                return .success(country)
            }
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    func loadProvinceData(for country: Country) {
        loadProvinceData(for: country.code)
    }
    
    func loadProvinceData(for countryCode: String) {
        DispatchQueue.main.async {
            self.loadingTasks.insert(.provinceData(countryCode: countryCode))
        }
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        country.code = countryCode // is this needed? Don't wanna search all this..
        DataManager.getProvinceData(for: country) { result in
            switch Self.parseProvinceData(result, country: country) {
            case .success(let country):
                self.pendingTasks.remove(.provinceData(countryCode: countryCode))
                DispatchQueue.main.async {
                    if let idx = self.countries.firstIndex(of: country) {
                        self.countries[idx] = country
                    }
                    self.error = nil
                }
                DispatchQueue.global().async {
                    indexForSpotlight(countries: self.countries)
                }
            case .failure(let error):
                self.handleError(error, task: .provinceData(countryCode: countryCode))
            }
            DispatchQueue.main.async {
                self.loadingTasks.remove(.provinceData(countryCode: countryCode))
            }
        }
    }
    
    
    // MARK: sortCountries()
    
    
    private func sortCountries() {
        countries.sort(by: { lhs, rhs in
            var lt: Bool
            switch sortBy {
            case .countryCode:
                lt = lhs.code < rhs.code
            case .countryName:
                lt =  lhs.name < rhs.name
            case .totalConfirmed:
                lt =  lhs.latest.totalConfirmed < rhs.latest.totalConfirmed
            case .newConfirmed:
                lt =  lhs.latest.newConfirmed < rhs.latest.newConfirmed
            case .totalDeaths:
                lt =  lhs.latest.totalDeaths < rhs.latest.totalDeaths
            case .newDeaths:
                lt =  lhs.latest.newDeaths < rhs.latest.newDeaths
            case .totalRecovered:
                lt =  lhs.latest.totalRecovered < rhs.latest.totalRecovered
            case .newRecovered:
                lt =  lhs.latest.newRecovered < rhs.latest.newRecovered
            case .activeCases:
                lt = lhs.activeCases ?? 0 < rhs.activeCases ?? 0
            }
            if reversed {
                return !lt
            } else {
                return lt
            }
        })
    }
    
    
    // MARK: Life cycle
    
    
    init() {
        latestGlobal = nil
        countries = [Country]()
        _sortBy = .countryCode
        _reversed = false
        pendingTasks = .init()
        loadingTasks = .init()
        
        self.reachability = try! Reachability()
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                if self.error == .some(.constrainedNetwork) || self.error == .some(.noNetworkConnection) {
                    DispatchQueue.main.async {
                        self.error = nil
                    }
                }
                for task in self.pendingTasks {
                    self.execute(task: task)
                }
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Couldn't start Reachability notifier: \(error.localizedDescription)")
        }
        
        if reachability.connection == .unavailable {
            DispatchQueue.main.async {
                self.error = .noNetworkConnection
                self.loadingTasks = .init()
                self.pendingTasks.insert(.summary)
            }
        } else {
            execute(task: .summary)
        }
    }
    
    func reset() {
        latestGlobal = nil
        countries = []
        error = nil
        sortBy = .countryCode
        reversed = false
        pendingTasks = .init() // summary loading to be invoked somewhere else
        loadingTasks = .init()
    }
    
    
    // MARK: Error handling
    
    
    private func handleError(_ error: NetworkError?, task: DataTask) {
        DispatchQueue.main.async {
            self.error = error
        }
        if error == .noNetworkConnection || error == .constrainedNetwork {
            pendingTasks.insert(task)
        }
    }
    
    // MARK: CountrySortingCriteria
    
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, activeCases
    }
    
    
    // MARK: Task management
    
    
    func execute(task: DataTask) {
        switch task {
        case .summary:
            self.loadSummary()
        case .globalSummary:
            self.loadGlobalSummary()
        case .historyData(countryCode: let countryCode):
            self.loadHistoryData(for: countryCode)
        case .provinceData(countryCode: let countryCode):
            self.loadProvinceData(for: countryCode)
        }
    }
    
    
    enum DataTask: Hashable {
        case summary
        case globalSummary
        case historyData(countryCode: String)
        case provinceData(countryCode: String)
    }
}


