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
    var loading: Bool { _loading }
    
    private var dataTasks: Set<DataTask>
    private let reachability: Reachability
    private var _loading = false
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
    
    
    class func getSummary(completion: @escaping (Data?, NetworkError?) -> Void) {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, NetworkError(error: error))
        }.resume()
    }
    
    class func parseSummary(_ data: Data?, _ error: Error?) -> Result<[Country], NetworkError> {
        if let error = error {
            if let error = error as? URLError {
                return .failure(.urlError(error))
            } else {
                return .failure(.otherWith(error: error))
            }
        } else if let data = data {
            let result = SummaryResponse.decode(from: data)
            switch result {
            case .failure(let error):
                switch error {
                case .decodingError(_):
                    let result2 = ServerCachingInProgressResponse.decode(from: data)
                    switch result2 {
                    case .success(let response):
                        if response.message.lowercased() == "caching in progress" {
                            return .failure(.cachingInProgress)
                        } else {
                            let string = String(data: data, encoding: .utf8) ?? Constants.notAvailableString
                            return .failure(.invalidResponse(response: string))
                        }
                    case .failure(let error):
                        return .failure(.init(error: error))
                    }
                default:
                    return .failure(NetworkError(error: error))
                }
            case .success(let response):
                var tempCountries = [Country]()
                for country in response.countries {
                    let measurement = country.toCountrySummaryMeasurement()
                    
                    let newCountry = Country(code: country.countryCode, name: country.country, latest: measurement)
                    tempCountries.append(newCountry)
                }
                return .success(tempCountries)
            }
        } else {
            return .failure(.noResponse)
        }
    }
    
    func loadSummary() {
        DispatchQueue.main.async {
            self._loading = true
        }
        Self.getSummary { data, error in
            switch Self.parseSummary(data, error) {
            case .success(let countries):
                self.dataTasks.remove(.summary)
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
                self._loading = false
            }
        }
    }
    
    
    // MARK: Global summary
    
    
    class func getGlobalSummary(completion: @escaping (Result<GlobalMeasurement, NetworkError>) -> Void) {
        guard let url = URL(string: "https://covid-api.com/api/reports/total") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.init(error: error)))
            } else if let data = data {
                /// That's what I call _dense_
                completion(GlobalMeasurementResponse.decode(from: data).map {$0.toGlobalMeasurement()}.mapError {NetworkError(error: $0)})
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
    }
    
    
    func loadGlobalSummary() {
        DispatchQueue.main.async {
            self._loading = true
        }
        Self.getGlobalSummary { result in
            switch result {
            case .success(let globalMeasurement):
                DispatchQueue.global().async {
                    indexGlobalMeasurementForSpotlight(globalMeasurement)
                }
                DispatchQueue.main.async {
                    self.latestGlobal = globalMeasurement
                    self.error = nil
                }
            case .failure(let error):
                self.handleError(error, task: .summary)
            }
            DispatchQueue.main.async {
                self._loading = false
            }
        }
    }
    
    
    // MARK: Country history data
    
    
    class func getHistoryData(for country: Country, completion: @escaping (Result<(Country, [CountryHistoryMeasurementForDecodingOnly]), NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.covid19api.com/total/country/\(country.code)") else { return }
        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = UserDefaults().bool(forKey: UserDefaultsKeys.ignoreLowDataMode)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.init(error: error)))
            } else if let data = data {
                completion([CountryHistoryMeasurementForDecodingOnly].decode(from: data).map {(country, $0)}.mapError {NetworkError(error: $0)})
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
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
            self._loading = true
        }
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        country.code = countryCode // is this needed? Don't wanna search all this..
        
        Self.getHistoryData(for: country) { result in
            switch Self.parseHistoryData(result) {
            case .success(let country):
                self.dataTasks.remove(.historyData(countryCode: countryCode))
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
                self._loading = false
            }
        }
    }
    
    
    // MARK: Province data
    
    
    class func getProvinceData(for country: Country, at date: Date? = nil, completion: @escaping (Result<CountryProvincesResponse, NetworkError>) -> Void) {
        let code = Constants.alpha2_to_alpha3_countryCodes[country.code] as? String ?? country.code
        var components = URLComponents()
        components.scheme = "https"
        components.host = "covid-api.com"
        components.path = "/api/reports"
        components.queryItems = [.init(name: "iso", value: code)]
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "Y-m-d" // why do they have different date formats as in/outputs?
            components.queryItems?.append(.init(name: "date", value: formatter.string(from: date)))
        }
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = UserDefaults().bool(forKey: UserDefaultsKeys.ignoreLowDataMode)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.init(error: error)))
            } else if let data = data {
                completion(CountryProvincesResponse.decode(from: data).mapError {NetworkError(error: $0)})
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
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
            self._loading = true
        }
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        country.code = countryCode // is this needed? Don't wanna search all this..
        DataManager.getProvinceData(for: country) { result in
            switch Self.parseProvinceData(result, country: country) {
            case .success(let country):
                self.dataTasks.remove(.provinceData(countryCode: countryCode))
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
                self._loading = false
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
        dataTasks = .init()
        
        self.reachability = try! Reachability()
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                DispatchQueue.main.async {
                    self.error = nil
                }
                for task in self.dataTasks {
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
                self._loading = false
            }
        } else {
            execute(task: .summary)
        }
    }
    
    func reset() {
        latestGlobal = nil
        countries = [Country]()
        sortBy = .countryCode
        reversed = false
    }
    
    
    // MARK: Error handling
    
    
    private func handleError(_ error: NetworkError?, task: DataTask) {
        DispatchQueue.main.async {
            self.error = error
        }
        if error == .noNetworkConnection || error == .constrainedNetwork {
            dataTasks.insert(task)
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
            self.loadGlobalSummary()
            self.loadSummary()
        case .historyData(countryCode: let countryCode):
            self.loadHistoryData(for: countryCode)
        case .provinceData(countryCode: let countryCode):
            self.loadProvinceData(for: countryCode)
        }
    }
    
    
    enum DataTask: Hashable {
        case summary
        case historyData(countryCode: String)
        case provinceData(countryCode: String)
    }
}


