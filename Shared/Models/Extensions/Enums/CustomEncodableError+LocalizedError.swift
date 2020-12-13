//
//  CustomEncodableError+LocalizedError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension CustomEncodableError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .other(let error):
            return error.localizedDescription
        }
    }
}
