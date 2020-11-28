//
//  Country.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

class Country: SummaryProvider {
    var totalConfirmed: Int { latest.totalConfirmed }
    var newConfirmed: Int { latest.newConfirmed }
    var totalDeaths: Int { latest.totalDeaths }
    var newDeaths: Int { latest.newDeaths }
    var totalRecovered: Int { latest.totalRecovered }
    var newRecovered: Int { latest.newRecovered }
    var activeCases: Int? { latest.active ?? totalConfirmed - totalRecovered - totalDeaths}
    var newActive: Int? { latest.newActive }
    var caseFatalityRate: Double? { latest.caseFatalityRate }
    var provinces: [Province]
    var active: Int? { activeCases }
    
    var code: String
    var name: String
    var latest: CountrySummaryMeasurement
    var measurements: [CountryHistoryMeasurement]
    
    init(code: String, name: String, latest: CountrySummaryMeasurement, measurements: [CountryHistoryMeasurement] = [], provinces: [Province] = []) {
        self.code = code
        self.name = name
        self.latest = latest
        self.measurements = measurements
        self.provinces = provinces
    }
}
