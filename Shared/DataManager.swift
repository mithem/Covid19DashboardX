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
    
    var error: NetworkError? { // this should be the definition of weird, just to not change the code below…
        get { nil }
        set {
            delegate?.error(newValue ?? .other)
        }
    }
    
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
    
    func loadSummary() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    if let error = error as? URLError {
                        self.error = .urlError(error)
                    } else {
                        self.error = .otherWith(error: error)
                    }
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode(SummaryResponse.self, from: data)
                if let serverResponse = serverResponse {
                    var tempCountries = [Country]()
                    for country in serverResponse.countries {
                        let measurement = CountrySummaryMeasurement(date: country.date, totalConfirmed: country.totalConfirmed, newConfirmed: country.newConfirmed, totalDeaths: country.totalDeaths, newDeaths: country.newDeaths, totalRecovered: country.totalRecovered, newRecovered: country.newRecovered)
                        
                        let newCountry = Country(code: country.countryCode, name: country.country, latest: measurement)
                        tempCountries.append(newCountry)
                    }
                    DispatchQueue.main.async {
                        self.sortCountries()
                        self.countries = tempCountries
                        self.latestGlobal = serverResponse.global
                        self.error = nil
                    }
                } else {
                    print("Invalid response.")
                    let resp = String(data: data, encoding: .utf8)
                    print(resp ?? notAvailableString)
                    DispatchQueue.main.async {
                        self.error = .invalidResponse(response: resp ?? notAvailableString)
                    }
                }
            } else {
                print("No response.")
                DispatchQueue.main.async {
                    self.error = .noResponse
                }
            }
        }.resume()
    }
    
    func loadData(for country: Country) {
        guard let url = URL(string: "https://api.covid19api.com/total/country/\(country.code)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    if let error = error as? URLError {
                        self.error = .urlError(error)
                    } else {
                        self.error = .otherWith(error: error)
                    }
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                var serverResponse: [CountryHistoryMeasurementForDecodingOnly]?
                do {
                    serverResponse = try decoder.decode([CountryHistoryMeasurementForDecodingOnly].self, from: data)
                } catch {
                    print(error)
                }
                if let serverResponse = serverResponse {
                    guard let country = self.countries.first(where: {$0 == country}) else { return }
                    
                    for measurement in serverResponse {
                        country.measurements.append(CountryHistoryMeasurement(confirmed: measurement.cases ?? measurement.confirmed ?? 0, deaths: measurement.deaths, recovered: measurement.recovered, active: measurement.active, date: measurement.date))
                    }
                    DispatchQueue.main.async {
                        if let idx = self.countries.firstIndex(of: country) {
                            self.countries[idx] = country
                        }
                    }
                    DispatchQueue.main.async {
                        self.error = nil
                    }
                } else {
                    print("Invalid response.")
                    DispatchQueue.main.async {
                        self.error = .invalidResponse(response: String(data: data, encoding: .utf8) ?? notAvailableString)
                    }
                }
            } else {
                print("No response.")
                DispatchQueue.main.async {
                    self.error = .noResponse
                }
            }
        }.resume()
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
    }
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, activeCases
    }
}

protocol DataManagerDelegate {
    func error(_ error: NetworkError)
}
