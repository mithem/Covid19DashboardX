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
        }
    }
    class Encoder: CustomJSONEncoder {
        required init() {
            super.init()
            keyEncodingStrategy = .convertToPascalCase
        }
    }
    
    let message: String
    let countries: [CountrySummaryMeasurementForDecodingOnly]
}
