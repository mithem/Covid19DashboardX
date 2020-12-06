//
//  GlobalMeasurementForDecodingOnly.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 05.12.20.
//

import Foundation

struct GlobalMeasurementForDecodingOnly: Decodable, Equatable {
    let lastUpdate: Date
    let confirmed: Int
    let confirmedDiff: Int
    let recovered: Int
    let recoveredDiff: Int
    let deaths: Int
    let deathsDiff: Int
    let active: Int
    let activeDiff: Int
    let fatalityRate: Double
    
    func toGlobalMeasurement() -> GlobalMeasurement {
        return .init(lastUpdate: lastUpdate, totalConfirmed: confirmed, newConfirmed: confirmedDiff, totalDeaths: deaths, newDeaths: deathsDiff, totalRecovered: recovered, newRecovered: recoveredDiff, active: active, newActive: activeDiff, caseFatalityRate: fatalityRate)
    }
}
