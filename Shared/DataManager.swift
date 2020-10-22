//
//  DataManager.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import Network

class DataManager: ObservableObject, Equatable {
    static func == (lhs: DataManager, rhs: DataManager) -> Bool {
        return lhs.countries == rhs.countries
    }
    
    @Published var countries: [Country]
    @Published var latestGlobal: GlobalMeasurement?
    @Published var error: NetworkError?
    
    private let monitor: NWPathMonitor
    private var _sortBy: CountrySortingCriteria
    var delegate: DataManagerDelegate?
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
    
    static func getSummary(completion: @escaping (Result<SummaryResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
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
    
    func loadSummary() {
        DataManager.getSummary { result in
            switch result {
            case .success(let response):
                var tempCountries = [Country]()
                for country in response.countries {
                    let measurement = CountrySummaryMeasurement(date: country.date, totalConfirmed: country.totalConfirmed, newConfirmed: country.newConfirmed, totalDeaths: country.totalDeaths, newDeaths: country.newDeaths, totalRecovered: country.totalRecovered, newRecovered: country.newRecovered)
                    
                    let newCountry = Country(code: country.countryCode, name: country.country, latest: measurement)
                    tempCountries.append(newCountry)
                }
                DispatchQueue.main.async {
                    self.sortCountries()
                    self.countries = tempCountries
                    self.latestGlobal = response.global
                    self.error = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
    
    typealias GetDataCompletionHandler = (Result<Country, NetworkError>) -> Void
    
    static func getData(for country: Country, previousCountry: Country, completion: @escaping GetDataCompletionHandler) {
        getData(for: country.code, previousCountry: previousCountry, completion: completion)
    }
    
    static func getData(for countryCode: String, previousCountry: Country, completion: @escaping GetDataCompletionHandler) {
        guard let url = URL(string: "https://api.covid19api.com/total/country/\(countryCode)") else { return }
        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = false
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
                    for measurement in serverResponse {
                        previousCountry.measurements.append(CountryHistoryMeasurement(confirmed: measurement.cases ?? measurement.confirmed ?? 0, deaths: measurement.deaths, recovered: measurement.recovered, active: measurement.active, date: measurement.date))
                    }
                    completion(.success(previousCountry))
                } else {
                    completion(.failure(.invalidResponse))
                }
            } else {
                completion(.failure(.noResponse))
            }
        }.resume()
    }
    
    func loadData(for country: Country) {
        self.loadData(for: country.code)
    }
    
    func loadData(for countryCode: String) {
        guard let country = self.countries.first(where: {$0.code == countryCode}) else { return }
        DataManager.getData(for: countryCode, previousCountry: country) { result in
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
        }
    }
    
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
                lt = lhs.active < rhs.active
            }
            if reversed {
                return !lt
            } else {
                return lt
            }
        })
    }
    
    init(delegate: DataManagerDelegate? = nil) {
        latestGlobal = nil
        countries = [Country]()
        _sortBy = .countryCode
        _reversed = false
        self.delegate = delegate
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.loadSummary()
            }
        }
        loadSummary()
    }
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, activeCases
    }
}

protocol DataManagerDelegate {
    func error(_ error: NetworkError)
}
