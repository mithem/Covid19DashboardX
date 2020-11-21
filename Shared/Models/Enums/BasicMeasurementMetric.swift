//
//  BasicMeasurementMetric.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum BasicMeasurementMetric: String, Decodable, CaseIterable, Identifiable {
    var id: BasicMeasurementMetric { self }
    
    case confirmed = "confirmed"
    case deaths = "deaths"
    case recovered = "recovered"
    case active = "active"
    
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
