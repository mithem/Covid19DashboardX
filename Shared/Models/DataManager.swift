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
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Published var countries: [Country]
    @Published var latestGlobal: GlobalMeasurement?
    @Published var error: NetworkError?
    var loading: Bool { _loading }
    
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
    
    
    class func getSummary(completion: @escaping (Result<SummaryResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if let error = error as? URLError {
                    completion(.failure(.urlError(error)))
                } else {
                    completion(.failure(.otherWith(error: error)))
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode(SummaryResponse.self, from: data)
                if let serverResponse = serverResponse {
                    completion(.success(serverResponse))
                } else {
                    completion(.failure(.noResponse))
                }
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
    }
    
    class func parseSummary(_ data: Result<SummaryResponse, NetworkError>) -> Result<(countries: [Country], latestGlobal: GlobalMeasurement), NetworkError> {
        switch data {
        case .success(let response):
            var tempCountries = [Country]()
            for country in response.countries {
                let measurement = CountrySummaryMeasurement(date: country.date, totalConfirmed: country.totalConfirmed, newConfirmed: country.newConfirmed, totalDeaths: country.totalDeaths, newDeaths: country.newDeaths, totalRecovered: country.totalRecovered, newRecovered: country.newRecovered, active: country.active, newActive: country.newActive, caseFatalityRate: country.caseFatalityRate)
                
                let newCountry = Country(code: country.countryCode, name: country.country, latest: measurement)
                tempCountries.append(newCountry)
            }
            return .success((countries: tempCountries, latestGlobal: response.global))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// load Summary from Self.getSummary and call `callback` when done.
    /// - Parameter callback: function to call back
    func loadSummary(callback: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self._loading = true
        }
        Self.getSummary { result in
            switch Self.parseSummary(result) {
            case .success((let countries, let latestGlobal)):
                DispatchQueue.main.async {
                    self.sortCountries()
                    self.countries = countries
                    self.latestGlobal = latestGlobal
                    self.error = nil
                    self._loading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                    self._loading = false
                }
            }
            if let callback = callback {
                callback()
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
                if let error = error as? URLError {
                    if error.networkUnavailableReason == .constrained {
                        completion(.failure(.constrainedNetwork))
                    } else {
                        completion(.failure(.urlError(error)))
                    }
                } else {
                    completion(.failure(.otherWith(error: error)))
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode([CountryHistoryMeasurementForDecodingOnly].self, from: data)
                if let serverResponse = serverResponse {
                    completion(.success((country, serverResponse)))
                } else {
                    completion(.failure(.invalidResponse(response: String(data: data, encoding: .utf8) ?? Constants.notAvailableString)))
                }
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
    }
    
    class func parseHistoryData(_ data: Result<(Country, [CountryHistoryMeasurementForDecodingOnly]), NetworkError>) -> CountryDataResult {
        switch data {
        case .success(let (country, measurements)):
            for measurement in measurements {
                country.measurements.append(CountryHistoryMeasurement(confirmed: measurement.cases ?? measurement.confirmed ?? 0, deaths: measurement.deaths, recovered: measurement.recovered, active: measurement.active, date: measurement.date))
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
                DispatchQueue.main.async {
                    if let idx = self.countries.firstIndex(of: country) {
                        self.countries[idx] = country
                    }
                    self.error = nil
                    self._loading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                    self._loading = false
                }
            }
        }
    }
    
    
    // MARK: Detailed country data (CFR etc)
    
    
    /// get country data like the CFR and active cases from covid-api.com
    class func getDetailedCountryData(for country: Country, at date: Date? = nil, completion: @escaping GetCountryDataCompletionHandler) {
        let code = Constants.alpha2_to_alpha3_countryCodes[country.code] as? String ?? country.code
        var components = URLComponents()
        components.scheme = "https"
        components.host = "covid-api.com"
        components.path = "/api/reports/total"
        components.queryItems = [.init(name: "iso", value: code)]
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "Y-m-d" // why do they have different date formats as in/outputs?
            components.queryItems?.append(.init(name: "date", value: formatter.string(from: date)))
        }
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if let error = error as? URLError {
                    completion(.failure(.urlError(error)))
                } else {
                    completion(.failure(.otherWith(error: error)))
                }
            } else if let data = data {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.covidDashApiDotComDateFormat
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(formatter)
                let serverResponse = try? decoder.decode(DetailedCountryMeasurementResponse.self, from: data)
                if let serverResponse = serverResponse {
                    country.latest.active = serverResponse.data.active
                    country.latest.caseFatalityRate = serverResponse.data.fatalityRate
                    country.latest.date = serverResponse.data.date
                    country.latest.newActive = serverResponse.data.activeDiff
                    country.latest.newConfirmed = serverResponse.data.confirmedDiff
                    country.latest.newDeaths = serverResponse.data.deathsDiff
                    country.latest.newRecovered = serverResponse.data.recoveredDiff
                    country.latest.totalConfirmed = serverResponse.data.confirmed
                    country.latest.totalRecovered = serverResponse.data.recovered
                    country.latest.totalDeaths = serverResponse.data.deaths
                    
                    completion(.success(country))
                } else {
                    completion(.failure(.invalidResponse(response: String(data: data, encoding: .utf8) ?? Constants.notAvailableString)))
                }
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
    }
    
    func loadDetailedCountryData(for country: Country, at date: Date? = nil) {
        loadDetailedCountryData(for: country.code, at: date)
    }
    
    func loadDetailedCountryData(for countryCode: String, at date: Date? = nil) {
        DispatchQueue.main.async {
            self._loading = true
        }
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        country.code = countryCode // is this needed? Don't wanna search all this..
        Self.getDetailedCountryData(for: country, at: date) { result in
            switch result {
            case .success(let country):
                DispatchQueue.main.async {
                    if let idx = self.countries.firstIndex(of: country) {
                        self.countries[idx] = country
                    }
                    self.error = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                }
            }
            DispatchQueue.main.async {
                self._loading = false
            }
        }
    }
    
    
    // MARK: Province data
    
    
    class func getProvinceData(for country: Country, at date: Date? = nil, completion: @escaping GetCountryDataCompletionHandler) {
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
                if let error = error as? URLError {
                    if error.networkUnavailableReason == .constrained {
                        completion(.failure(.constrainedNetwork))
                    } else {
                        completion(.failure(.urlError(error)))
                    }
                } else {
                    completion(.failure(.otherWith(error: error)))
                }
            } else if let data = data {
                let decoder = CovidDashApiDotComJSONDecoder()
                let serverResponse = try? decoder.decode(CountryProvincesResponse.self, from: data)
                if let serverResponse = serverResponse {
                    if serverResponse.data.isEmpty {
                        completion(.failure(.noResponse))
                    } else {
                        for measurement in serverResponse.data {
                            if measurement.region.province != country.name && !measurement.region.province.isEmpty {
                                let newMeasurement = ProvinceMeasurement(date: measurement.date, totalConfirmed: measurement.confirmed, newConfirmed: measurement.confirmedDiff, totalRecovered: measurement.deaths, newRecovered: measurement.deathsDiff, totalDeaths: measurement.recovered, newDeaths: measurement.recoveredDiff, active: measurement.active, newActive: measurement.activeDiff, caseFatalityRate: measurement.fatalityRate)
                                let province = Province(name: measurement.region.province, measurements: [newMeasurement])
                                country.provinces.append(province)
                            }
                        }
                        completion(.success(country))
                    }
                } else {
                    let string = String(data: data, encoding: .utf8) ?? Constants.notAvailableString
                    completion(.failure(.invalidResponse(response: string)))
                }
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
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
            switch result {
            case .success(let country):
                DispatchQueue.main.async {
                    if let idx = self.countries.firstIndex(of: country) {
                        self.countries[idx] = country
                    }
                    self.error = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                }
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
        
        self.reachability = try! Reachability()
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                DispatchQueue.main.async {
                    self.error = nil
                }
                self.loadSummary()
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
            loadSummary()
        }
    }
    
    func reset() {
        latestGlobal = nil
        countries = [Country]()
        sortBy = .countryCode
        reversed = false
    }
    
    
    // MARK: CountrySortingCriteria
    
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, activeCases
    }
}


