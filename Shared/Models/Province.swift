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
    
    func value(for metric: MeasurementMetric) -> String {
        var v: Any
        switch metric {
        case .active:
            v =  activeCases as Any
        case .newActive:
            v =  newActive as Any
        case .totalConfirmed:
            v =  totalConfirmed
        case .newConfirmed:
            v =  newConfirmed
        case .totalRecovered:
            v =  totalRecovered
        case .newRecovered:
            v =  newRecovered
        case .totalDeaths:
            v =  totalDeaths
        case .newDeaths:
            v =  newDeaths
        case .caseFatalityRate:
            v =  caseFatalityRate as Any
        }
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        if let v = v as? Int {
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: v)) ?? Constants.notAvailableString
        } else if let v = v as? Double {
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 5
            return formatter.string(from: NSNumber(value: v)) ?? Constants.notAvailableString
        } else {
            return Constants.notAvailableString
        }
    }
    
    
    
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
