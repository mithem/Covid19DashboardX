//
//  ComplicationConstants.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 06.01.21.
//

import ClockKit

enum ComplicationIdentifier: String, CaseIterable {
    case globalActive = "globalActive"
    case globalConfirmed = "globalConfirmed"
    
    var displayName: String {
        switch self {
        case .globalActive:
            return "Global active"
        case .globalConfirmed:
            return "Global confirmed"
        }
    }
    
    var veryShort: String {
        switch self {
        case .globalActive:
            return NSLocalizedString("complication_identifier_very_short_global_active", comment: "complication_identifier_very_short_global_active")
        case .globalConfirmed:
            return NSLocalizedString("complication_identifier_very_short_global_confirmed", comment: "complication_identifier_very_short_global_confirmed")
        }
    }
    
    var measurementMetric: MeasurementMetric {
        switch self {
        case .globalActive:
            return .active
        case .globalConfirmed:
            return .totalConfirmed
        }
    }
    
    func makeDescriptor(_ supportedFamilies: CLKComplicationFamily...) -> CLKComplicationDescriptor {
        .init(identifier: self.rawValue, displayName: displayName, supportedFamilies: supportedFamilies)
    }
}

struct ComplicationDescriptors {
    static let globalActive = ComplicationIdentifier.globalActive.makeDescriptor(.graphicCorner, .graphicRectangular, .modularLarge)
    static let globalConfirmed = ComplicationIdentifier.globalConfirmed.makeDescriptor(.graphicCorner, .graphicRectangular, .modularLarge)
}
