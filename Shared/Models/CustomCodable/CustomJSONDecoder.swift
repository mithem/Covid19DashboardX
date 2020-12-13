//
//  CustomJSONDecoder.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

class CustomJSONDecoder: JSONDecoder, CustomJSONDecoderProtocol {
    required override init() {
        super.init()
    }
}
