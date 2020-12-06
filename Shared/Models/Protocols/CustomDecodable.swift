//
//  CustomDecodable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

protocol CustomDecodable: Decodable {
    associatedtype Decoder: CustomJSONDecoder
}
