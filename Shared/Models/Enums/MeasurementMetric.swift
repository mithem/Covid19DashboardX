//
//  MeasurementMetric.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum MeasurementMetric: CaseIterable, Identifiable {
    var id: Self { self }
    case active, newActive, totalConfirmed, newConfirmed, totalRecovered, newRecovered, totalDeaths, newDeaths, caseFatalityRate, exponentialProperty
}
