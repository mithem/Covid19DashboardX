//
//  GlobalMeasurementResponse.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

struct GlobalMeasurementResponse: CustomDecodable, Equatable {
    
    class Decoder: JSONDecoder, CustomJSONDecoder {
        typealias T = GlobalMeasurementResponse
        
        override init() {
            super.init()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-mm-DD HH:mm:ss"
            dateDecodingStrategy = .formatted(dateFormatter)
            keyDecodingStrategy = .convertFromSnakeCase
        }
    }
    
    let data: GlobalMeasurementForDecodingOnly
    
    func toGlobalMeasurement() -> GlobalMeasurement {
        return data.toGlobalMeasurement()
    }
}
