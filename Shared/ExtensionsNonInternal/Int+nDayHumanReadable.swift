//
//  Int+nDayHumanReadable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension Int {
    
    /// formatted String for self (n) days
    var nDaysHumanReadable: String {
        let formatter = DateComponentsFormatter()
        let dateComponents = DateComponents(day: self)
        formatter.allowedUnits = [.day, .month, .year]
        formatter.unitsStyle = .full
        
        return formatter.string(from: dateComponents) ?? Constants.notAvailableString
    }
}
