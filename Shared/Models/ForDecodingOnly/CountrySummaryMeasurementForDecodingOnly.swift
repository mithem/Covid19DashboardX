//
//  CountrySummaryMeasurementForDecodingOnly.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountrySummaryMeasurementForDecodingOnly: Decodable, Identifiable {
    
    var id: String { countryCode }
    let country: String
    let countryCode: String
    let date: Date
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let active: Int?
    let newActive: Int?
    let caseFatalityRate: Double?
    let slug: String?
    
    init(country: String, countryCode: String, date: Date, totalConfirmed: Int, newConfirmed: Int, totalDeaths: Int, newDeaths: Int, totalRecovered: Int, newRecovered: Int, slug: String? = nil, active: Int? = nil, newActive: Int? = nil, caseFatalityRate: Double?) {
        self.country = country
        self.countryCode = countryCode
        self.date = date
        self.totalConfirmed = totalConfirmed
        self.newConfirmed = newConfirmed
        self.totalDeaths = totalDeaths
        self.newDeaths = newDeaths
        self.totalRecovered = totalRecovered
        self.newRecovered = newRecovered
        self.slug = slug
        self.active = active
        self.newActive = newActive
        self.caseFatalityRate = caseFatalityRate
    }
    
    func toCountrySummaryMeasurement() -> CountrySummaryMeasurement {
        return .init(date: date, totalConfirmed: totalConfirmed, newConfirmed: newConfirmed, totalDeaths: totalDeaths, newDeaths: newDeaths, totalRecovered: totalRecovered, newRecovered: newRecovered, active: active, newActive: newActive, caseFatalityRate: caseFatalityRate)
    }
}
