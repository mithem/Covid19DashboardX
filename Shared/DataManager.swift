//
//  DataManager.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

class DataManager: ObservableObject, Equatable {
    static func == (lhs: DataManager, rhs: DataManager) -> Bool {
        let m = lhs.latestMeasurements == rhs.latestMeasurements
        let g = lhs.latestGlobal == rhs.latestGlobal
        let c = lhs.countries == rhs.countries
        return m && g && c
    }
    
    
    @Published var latestMeasurements: [CountrySummaryMeasurement]
    @Published var latestGlobal: GlobalMeasurement?
    @Published var countries: [Country]
    private var subscribers: [DataManagerHistorySubscriber]
    
    private var _sortBy: CountrySortingCriteria
    var sortBy: CountrySortingCriteria {
        get {
            _sortBy
        }
        set {
            _sortBy = newValue
            sortLatestMeasurements()
        }
    }
    private var _reversed: Bool
    var reversed: Bool {
        get {
            _reversed
        }
        set {
            _reversed = newValue
            sortLatestMeasurements()
        }
    }
    
    func loadSummary() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode(SummaryResponse.self, from: data)
                if let serverResponse = serverResponse {
                    DispatchQueue.main.async {
                        self.latestMeasurements = serverResponse.countries
                        self.sortLatestMeasurements()
                        self.latestGlobal = serverResponse.global
                    }
                } else {
                    print("Invalid response.")
                }
            } else {
                print("No response.")
            }
        }.resume()
    }
    
    func getHistory(for country: String) -> [CountryHistoryMeasurement]? {
        return countries.first(where: {country == $0.code || country == $0.name})?.measurements
    }
    
    func loadData(for country: String) {
        guard let url = URL(string: "https://api.covid19api.com/total/country/\(country)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                var serverResponse: [CountryHistoryMeasurementForDecodingOnly]?
                do {
                    serverResponse = try decoder.decode([CountryHistoryMeasurementForDecodingOnly].self, from: data)
                } catch {
                    print(error)
                    print(String(data: data, encoding: .utf8))
                }
                if let serverResponse = serverResponse {
                    var tempCountries = [Country]() // only wanna call the main thread once
                    guard let countryName = serverResponse.first?.country.lowercased() else { return }
                    guard let countryCode = serverResponse.first?.countryCode.lowercased() else { return }
                    
                    var country = Country(code: countryCode, name: countryName, measurements: [])
                    
                    for measurement in serverResponse {
                        country.measurements.append(CountryHistoryMeasurement(confirmed: measurement.cases ?? measurement.confirmed ?? 0, deaths: measurement.deaths, recovered: measurement.recovered, active: measurement.active, date: measurement.date, status: measurement.status ?? .confirmed))
                    }
                    tempCountries.append(country)
                    
                    DispatchQueue.main.async {
                        self.countries = tempCountries
                        print("loaded successfully: \(self.countries.count) items")
                    }
                    for subscriber in self.subscribers {
                        subscriber.didUpdateHistory(new: self.countries)
                    }
                } else {
                    print("Invalid response.")
                }
            } else {
                print("No response.")
            }
        }.resume()
    }
    
    private func sortLatestMeasurements() {
        latestMeasurements.sort(by: { lhs, rhs in
            var lt: Bool
            switch sortBy {
            case .countryCode:
                lt =  lhs.countryCode < rhs.countryCode
            case .countryName:
                lt =  lhs.country < rhs.country
            case .totalConfirmed:
                lt =  lhs.totalConfirmed < rhs.totalConfirmed
            case .newConfirmed:
                lt =  lhs.newConfirmed < rhs.newConfirmed
            case .totalDeaths:
                lt =  lhs.totalDeaths < rhs.totalDeaths
            case .newDeaths:
                lt =  lhs.newDeaths < rhs.newDeaths
            case .totalRecovered:
                lt =  lhs.totalRecovered < rhs.totalRecovered
            case .newRecovered:
                lt =  lhs.newRecovered < rhs.newRecovered
            case .slug:
                lt =  lhs.slug ?? "N/A" < rhs.slug ?? "N/A"
            }
            if reversed {
                return !lt
            } else {
                return lt
            }
        })
    }
    
    init() {
        latestMeasurements = [CountrySummaryMeasurement]()
        latestGlobal = nil
        countries = [Country]()
        _sortBy = .countryCode
        _reversed = false
        subscribers = []
    }
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, slug
    }
}

protocol DataManagerHistorySubscriber: Equatable {
    func didUpdateHistory(new countries: [Country])
}
