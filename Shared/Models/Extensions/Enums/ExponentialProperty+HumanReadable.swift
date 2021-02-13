//
//  ExponentialProperty+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 11.02.21.
//

import Foundation

extension ExponentialProperty {
    var humanReadable: String {
        switch self {
        case .doublingTime(_):
            return "Doubling time"
        case .halvingTime(_):
            return "Halving time"
        case .none:
            return "None"
        }
    }
}
