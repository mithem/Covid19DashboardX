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
}
