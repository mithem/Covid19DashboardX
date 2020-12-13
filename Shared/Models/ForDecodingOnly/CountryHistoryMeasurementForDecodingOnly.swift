//
//  CountryHistoryMeasurementForDecodingOnly.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct CountryHistoryMeasurementForDecodingOnly: CustomDecodable {
    class Decoder: CustomJSONDecoder {
        required init() {
            super.init()
            keyDecodingStrategy = .convertFromPascalCase
            dateDecodingStrategy = .iso8601
        }
    }
    
    var cases: Int?
    var confirmed: Int?
    var deaths: Int?
    var recovered: Int?
    var active: Int
    var caseFatalityRate: Double?
    var date: Date
    var status: BasicMeasurementMetric?
    var country: String
    var countryCode: String
    var lat: String
    var lon: String
    
    func toCountryHistoryMeasurement() -> CountryHistoryMeasurement {
        return .init(confirmed: confirmed ?? 0, deaths: deaths, recovered: recovered, active: active, date: date, caseFatalityRate: caseFatalityRate)
    }
}
