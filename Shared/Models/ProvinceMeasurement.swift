//
//  ProvinceMeasurement.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct ProvinceMeasurement: Hashable {
    var date: Date
    var totalConfirmed: Int
    var newConfirmed: Int
    var totalRecovered: Int
    var newRecovered: Int
    var totalDeaths: Int
    var newDeaths: Int
    var active: Int
    var newActive: Int
    var caseFatalityRate: Double?
}
