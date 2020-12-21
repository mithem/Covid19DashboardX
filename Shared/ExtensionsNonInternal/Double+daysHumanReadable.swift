//
//  Double+daysHumanReadable.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 20.12.20.
//

import Foundation

extension Double {
    var daysHumanReadable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: self)) ?? Constants.notAvailableString
    }
}
