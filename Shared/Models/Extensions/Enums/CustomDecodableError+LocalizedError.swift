//
//  CustomDecodableError+LocalizedError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension CustomDecodableError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
