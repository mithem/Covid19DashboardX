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
    
    func makeDescriptor(_ supportedFamilies: CLKComplicationFamily...) -> CLKComplicationDescriptor {
        .init(identifier: self.rawValue, displayName: displayName, supportedFamilies: supportedFamilies)
    }
}

struct ComplicationDescriptors {
    static let globalActive = ComplicationIdentifier.globalActive.makeDescriptor(.graphicCorner)
    static let globalConfirmed = ComplicationIdentifier.globalConfirmed.makeDescriptor(.graphicCorner)
}
