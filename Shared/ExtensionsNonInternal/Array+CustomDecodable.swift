//
//  Array+CustomDecodable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

extension Array: CustomDecodable where Element: CustomDecodable {
    typealias Decoder = Element.Decoder
}
