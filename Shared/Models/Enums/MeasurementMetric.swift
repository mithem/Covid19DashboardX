//
//  MeasurementMetric.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum MeasurementMetric: CaseIterable, Identifiable {
    var id: MeasurementMetric { self }
    case active, newActive, totalConfirmed, newConfirmed, totalRecovered, newRecovered, totalDeaths, newDeaths, caseFatalityRate
    
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
        }
    }
}
