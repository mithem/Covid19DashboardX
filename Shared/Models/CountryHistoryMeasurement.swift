//
//  CountryHistoryMeasurement.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountryHistoryMeasurement: Equatable, Hashable {
    var confirmed: Int
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var date: Date
    var caseFatalityRate: Int?
    
    func metric(for basicMetric: BasicMeasurementMetric) -> Double {
        switch basicMetric {
        case .confirmed:
            return Double(confirmed)
        case .deaths:
            return Double(deaths ?? -1)
        case .recovered:
            return Double(recovered ?? -1)
        case .active:
            return Double(active ?? -1)
        }
    }
}
