//
//  BasicMeasurementMetric+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension BasicMeasurementMetric {
    var humanReadable: String {
        func s(_ key: String) -> String {
            return NSLocalizedString(key, comment: key)
        }
        switch self {
        case .confirmed:
            return s("confirmed_cases")
        case .deaths:
            return s("deaths")
        case .recovered:
            return s("recovered")
        case .active:
            return s("active_cases")
        }
    }
}
