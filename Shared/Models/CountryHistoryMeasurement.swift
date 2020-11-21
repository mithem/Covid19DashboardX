//
//  CountryHistoryMeasurement.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountryHistoryMeasurement: Equatable {
    var confirmed: Int
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var date: Date
    var caseFatalityRate: Int?
    
    func metric(for basicMetric: BasicMeasurementMetric) -> Int {
        switch basicMetric {
        case .confirmed:
            return confirmed
        case .deaths:
            return deaths ?? -1
        case .recovered:
            return recovered ?? -1
        case .active:
            return active ?? -1
        }
    }
}
