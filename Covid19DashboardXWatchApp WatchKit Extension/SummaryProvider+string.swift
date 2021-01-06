//
//  SummaryProvider+string.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 06.01.21.
//

import ClockKit

extension SummaryProvider {
    func string(for complication: ComplicationIdentifier) -> String {
        guard let v = value(for: complication) else { return Constants.notAvailableString }
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumSignificantDigits = 2
        return formatter.string(from: v as NSNumber) ?? Constants.notAvailableString
    }
}
