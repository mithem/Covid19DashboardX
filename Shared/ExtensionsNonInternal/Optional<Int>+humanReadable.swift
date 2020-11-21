//
//  Optional<Int>+humanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension Optional where Wrapped == Int {
    /// human-readable formatted String
    var humanReadable: String {
        if let n = self {
            return n.humanReadable
        } else {
            return Constants.notAvailableString
        }
    }
}
