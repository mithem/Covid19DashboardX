//
//  Province.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct Province: SummaryProvider, Equatable {
    var name: String
    var totalConfirmed: Int { measurements.last?.totalConfirmed ?? 0 }
    var newConfirmed: Int { measurements.last?.newConfirmed ?? 0 }
    var totalDeaths: Int { measurements.last?.totalDeaths ?? 0 }
    var newDeaths: Int { measurements.last?.newDeaths ?? 0 }
    var totalRecovered: Int { measurements.last?.totalRecovered ?? 0 }
    var newRecovered: Int { measurements.last?.newRecovered ?? 0 }
    var activeCases: Int? { measurements.last?.active }
    var newActive: Int? { measurements.last?.newActive }
    var caseFatalityRate: Double? { measurements.last?.caseFatalityRate }
    
    var active: Int? { activeCases }
    
    var measurements: [ProvinceMeasurement]
    
    enum SummaryMetric: String, CaseIterable, Identifiable {
        var id: SummaryMetric { self }
        case confirmed, recovered, deaths, active, caseFatalityRate
        
        var shortDescription: String {
            switch self {
            case .confirmed:
                return "Confirmed"
            case .recovered:
                return "Recovered"
            case .deaths:
                return "Deaths"
            case .active:
                return "Active"
            case .caseFatalityRate:
                return "CFR"
            }
        }
    }
}
