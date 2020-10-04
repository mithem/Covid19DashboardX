//
//  DataManager.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

class DataManager: ObservableObject {
    @Published var latestMeasurements: [CountryMeasurement]
    @Published var latestGlobal: GlobalMeasurement?
    private var _sortBy: CountrySortingCriteria
    var sortBy: CountrySortingCriteria {
        get {
            _sortBy
        }
        set {
            _sortBy = newValue
            sort()
        }
    }
    private var _reversed: Bool
    var reversed: Bool {
        get {
            _reversed
        }
        set {
            _reversed = newValue
            sort()
        }
    }
    
    func loadFromApi() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode(Response.self, from: data)
                if let serverResponse = serverResponse {
                    DispatchQueue.main.async {
                        self.latestMeasurements = serverResponse.countries
                        self.sort()
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
    
    private func sort() {
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
        latestMeasurements = [CountryMeasurement]()
        latestGlobal = nil
        _sortBy = .countryCode
        _reversed = false
    }
    
    enum CountrySortingCriteria {
        case countryCode, countryName, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, slug
    }
}
