//
//  CountrySummaryMeasurement.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountrySummaryMeasurement {
    var date: Date
    var totalConfirmed: Int
    var newConfirmed: Int
    var totalDeaths: Int
    var newDeaths: Int
    var totalRecovered: Int
    var newRecovered: Int
    var active: Int?
    var newActive: Int?
    var caseFatalityRate: Double?
}
