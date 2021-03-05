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
            return NSLocalizedString("no_data_present", comment: "no_data_present")
        case .decodingError(let error):
            return "\(NSLocalizedString("decoding_error_colon", comment: "decoding_error_colon"))\(error.localizedDescription)"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
