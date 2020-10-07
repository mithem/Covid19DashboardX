//
//  constants.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import Foundation

let notAvailableString = "N/A"

struct UserDefaultsKeys {
    /// Metric/Measurement shown in summary view
    static let ativeMetric = "activeMetric"
    static let colorNumbers = "colorNumbers"
    static let dataRepresentationType = "dataRepresentationType"
}

let countriesForPreviews = [Country(code: "US", name: "United States", latest: CountrySummaryMeasurement(date: Date() + 259_200, totalConfirmed: 200, newConfirmed: 50, totalDeaths: 18, newDeaths: 10, totalRecovered: 100, newRecovered: 30), measurements: [CountryHistoryMeasurement(confirmed: 100, deaths: 2, recovered: 20, active: 10, date: Date(), status: .confirmed), CountryHistoryMeasurement(confirmed: 120, deaths: 4, recovered: 35, active: 15, date: Date() + 86_400, status: .confirmed), CountryHistoryMeasurement(confirmed: 150, deaths: 8, recovered: 70, active: 20, date: Date() + 192_800, status: .confirmed)]), Country(code: "empty", name: "Empty country", latest: CountrySummaryMeasurement(date: Date(), totalConfirmed: 0, newConfirmed: 0, totalDeaths: 0, newDeaths: 0, totalRecovered: 0, newRecovered: 0))]

struct SpecialCountries {
    static let emptyCountry = countriesForPreviews[1]
}
