//
//  CustomEncodable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

protocol CustomEncodable: Encodable {
    associatedtype Encoder: CustomJSONEncoderProtocol
    func encode() -> Data
}

extension CustomEncodable {
    func encode() -> Data {
        return (try? Encoder().encode(self)) ?? Data()
    }
}
