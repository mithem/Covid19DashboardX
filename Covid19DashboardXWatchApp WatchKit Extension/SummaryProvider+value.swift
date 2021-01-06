//
//  SummaryProvider+value.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 06.01.21.
//

import Foundation

extension SummaryProvider {
    func value(for complication: ComplicationIdentifier) -> Int? {
        switch complication {
        case .globalActive:
            return activeCases
        case .globalConfirmed:
            return totalConfirmed
        }
    }
}
