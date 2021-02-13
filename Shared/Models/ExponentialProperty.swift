//
//  ExponentialProperty.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 11.02.21.
//

import Foundation

enum ExponentialProperty: Identifiable {
    var id: String { self.humanReadable }

    case doublingTime(_ value: Double)
    case halvingTime(_ value: Double)
    case none
}

extension ExponentialProperty {
    var value: Double? {
        switch self {
        case .doublingTime(let v), .halvingTime(let v):
            return v
        default:
            return nil
        }
    }
}
