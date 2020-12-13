//
//  CustomDecodableError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

enum CustomDecodableError: Error {
    case noData
    case decodingError(_ error: DecodingError)
    case other(_ error: Error)
}
