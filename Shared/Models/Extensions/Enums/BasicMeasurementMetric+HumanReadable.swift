//
//  BasicMeasurementMetric+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension BasicMeasurementMetric {
    var humanReadable: String {
        switch self {
        case .confirmed:
            return "Confirmed cases"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        case .active:
            return "Active cases"
        }
    }
}
