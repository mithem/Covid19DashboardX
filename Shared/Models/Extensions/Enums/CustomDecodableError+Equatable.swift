//
//  CustomDecodableError+Equatable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension CustomDecodableError: Equatable {
    static func == (lhs: CustomDecodableError, rhs: CustomDecodableError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
