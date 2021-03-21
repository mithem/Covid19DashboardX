//
//  CLKComplication+getEntry.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 20.03.21.
//

import Foundation
import ClockKit

extension CLKComplication {
    func getTimelineEntry(fillFraction: Float, latestMeasurement: GlobalMeasurement) -> CLKComplicationTimelineEntry? {
        guard let id = ComplicationIdentifier(rawValue: identifier) else { return nil }
        let now = Date()
        
        switch family {
        case .graphicCorner:
            return .init(date: now, complicationTemplate: CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: .ring, gaugeColors: [.green, .orange, .red], gaugeColorLocations: [0.1 as NSNumber, 0.65 as NSNumber, 0.9 as NSNumber], fillFraction: fillFraction), outerTextProvider: CLKSimpleTextProvider(text: latestMeasurement.string(for: id))))
        case .graphicRectangular:
            return .init(date: now, complicationTemplate: CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: CLKTextProvider(format: id.displayName), body1TextProvider: CLKTextProvider(format: latestMeasurement.value(for: id.measurementMetric))))
        case .modularLarge:
            return .init(date: now, complicationTemplate: CLKComplicationTemplateModularLargeTable(headerTextProvider: CLKTextProvider(format: NSLocalizedString("global", comment: "")), row1Column1TextProvider: CLKTextProvider(format: BasicMeasurementMetric.confirmed.shortDescription), row1Column2TextProvider: CLKTextProvider(format: latestMeasurement.value(for: .confirmed)), row2Column1TextProvider: CLKTextProvider(format: BasicMeasurementMetric.active.shortDescription), row2Column2TextProvider: CLKTextProvider(format: latestMeasurement.value(for: .active))))
        default:
            return nil
        }
    }
}
