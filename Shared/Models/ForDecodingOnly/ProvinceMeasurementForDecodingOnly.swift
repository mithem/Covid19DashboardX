//
//  ProvinceMeasurementForDecodingOnly.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct ProvinceMeasurementForDecodingOnly: Decodable {
    let date: Date
    let confirmed: Int
    let confirmedDiff: Int
    let deaths: Int
    let deathsDiff: Int
    let recovered: Int
    let recoveredDiff: Int
    let active: Int
    let activeDiff: Int
    let fatalityRate: Double
    let region: ProvinceMeasurementRegionForDecodingOnly
}
