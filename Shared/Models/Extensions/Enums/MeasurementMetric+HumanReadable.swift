//
//  MeasurementMetric+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation
extension MeasurementMetric {
    var humanReadable: String {
        switch self {
        case .active:
            return "Active"
        case .newActive:
            return "New active"
        case .totalConfirmed:
            return "Total confirmed"
        case .newConfirmed:
            return "New confirmed"
        case .totalRecovered:
            return "Total recovered"
        case .newRecovered:
            return "New recovered"
        case .totalDeaths:
            return "Total deaths"
        case .newDeaths:
            return "New deaths"
        case .caseFatalityRate:
            return "Case fatality rate"
        case .exponentialProperty:
            return "Case doubling/halving time"
        }
    }
}
