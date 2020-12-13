//
//  TimeInterval+shortDescription.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

extension TimeInterval {
    var shortDescription: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        if let v = formatter.string(from: NSNumber(value: self)) {
            return v + " d"
        } else {
            return Constants.notAvailableString
        }
    }
}
