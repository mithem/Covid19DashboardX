//
//  BasicMeasurementMetric+shortDescription.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension BasicMeasurementMetric {
    var shortDescription: String {
        switch self {
        case .confirmed:
            return "Confirmed"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        case .active:
            return "Active"
        }
    }
}
