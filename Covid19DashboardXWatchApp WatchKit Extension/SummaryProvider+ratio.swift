//
//  SummaryProvider+ratio.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 12.03.21.
//

import Foundation

extension SummaryProvider {
    func ratio(for complication: ComplicationIdentifier) -> Float? {
        switch complication {
        case .globalActive:
            guard let na = newActive, let ac = activeCases else { return nil }
            return Float(na) / Float(ac)
        case .globalConfirmed:
            return Float(newConfirmed) / Float(totalConfirmed)
        }
    }
}
