//
//  CustomJSONEncoder.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

class CustomJSONEncoder: JSONEncoder, CustomJSONEncoderProtocol {
    required override init() {
        super.init()
    }
}
