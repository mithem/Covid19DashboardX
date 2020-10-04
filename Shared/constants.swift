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
}

let countriesForPreviews = [Country(code: "US", name: "United States", measurements: [CountryHistoryMeasurement(confirmed: 100, deaths: 2, recovered: 20, active: 10, date: Date(), status: .confirmed), CountryHistoryMeasurement(confirmed: 120, deaths: 4, recovered: 35, active: 15, date: Date() + 86_400, status: .confirmed), CountryHistoryMeasurement(confirmed: 150, deaths: 8, recovered: 70, active: 20, date: Date() + 192_800, status: .confirmed)])]
