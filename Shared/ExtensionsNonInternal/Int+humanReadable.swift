//
//  Int+humanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation


extension Int {
    /// human-readable formatted String
    var humanReadable: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        
        return formatter.string(from: NSNumber(value: self)) ?? Constants.notAvailableString
    }
}
