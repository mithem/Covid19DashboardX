//
//  SummaryResponse.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct SummaryResponse: CustomCodable, Equatable {
    class Decoder: CustomJSONDecoder {
        required init() {
            super.init()
            keyDecodingStrategy = .convertFromPascalCase
            dateDecodingStrategy = .iso8601
        }
    }
    class Encoder: CustomJSONEncoder {
        required init() {
            super.init()
            keyEncodingStrategy = .convertToPascalCase
            dateEncodingStrategy = .iso8601
        }
    }
    
    let countries: [CountrySummaryMeasurementForDecodingOnly]
    let date: Date
}
