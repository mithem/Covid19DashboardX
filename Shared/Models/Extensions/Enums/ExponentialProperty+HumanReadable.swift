//
//  ExponentialProperty+HumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 11.02.21.
//

import Foundation

extension ExponentialProperty {
    var humanReadable: String {
        func s(_ key: String) -> String {
            return NSLocalizedString(key, comment: key)
        }
        switch self {
        case .doublingTime(_):
            return s("doubling_time")
        case .halvingTime(_):
            return s("halving_time")
        case .none:
            return s("none")
        }
    }
}
