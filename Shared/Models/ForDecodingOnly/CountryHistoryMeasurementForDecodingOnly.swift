//
//  CountryHistoryMeasurementForDecodingOnly.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountryHistoryMeasurementForDecodingOnly: Decodable {
    var cases: Int?
    var confirmed: Int?
    var deaths: Int?
    var recovered: Int?
    var active: Int
    var caseFatalityRate: Int?
    var date: Date
    var status: BasicMeasurementMetric?
    var country: String
    var countryCode: String
    var lat: String
    var lon: String
}
