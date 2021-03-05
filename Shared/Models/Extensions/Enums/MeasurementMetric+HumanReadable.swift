//
//  MeasurementMetric+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation
extension MeasurementMetric {
    var humanReadable: String {
        func s(_ key: String) -> String {
            return NSLocalizedString(key, comment: key)
        }
        switch self {
        case .active:
            return s("active")
        case .newActive:
            return s("new_active")
        case .totalConfirmed:
            return s("total_confirmed")
        case .newConfirmed:
            return s("new_confirmed")
        case .totalRecovered:
            return s("total_recovered")
        case .newRecovered:
            return s("new_recovered")
        case .totalDeaths:
            return s("total_deaths")
        case .newDeaths:
            return s("new_deaths")
        case .caseFatalityRate:
            return s("case_fatality_rate")
        case .exponentialProperty:
            return s("case_doubling_or_halving_time")
        }
    }
}
