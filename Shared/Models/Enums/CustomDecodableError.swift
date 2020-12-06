//
//  CustomDecodableError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

enum CustomDecodableError: Error, LocalizedError {
    case noData
    case other(_ error: Error)
    
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data."
        case .other(let error):
            return error.localizedDescription
        }
    }
}
