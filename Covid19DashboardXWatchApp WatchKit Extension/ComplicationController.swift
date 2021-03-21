//
//  ComplicationController.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 01.01.21.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            ComplicationDescriptors.globalActive,
            ComplicationDescriptors.globalConfirmed
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var colorTresholdForDeltas = UserDefaults().double(forKey: UserDefaultsKeys.colorTresholdForDeltas)
        if colorTresholdForDeltas == .zero {
            colorTresholdForDeltas = DefaultSettings.colorTresholdForDeltas
        }
        guard let complicationId = ComplicationIdentifier(rawValue: complication.identifier) else { handler(nil); return }
        DataManager.getGlobalSummary { result in
            switch result {
            case .success(let latest):
                guard let ratio = latest.ratio(for: complicationId) else { handler(nil); return }
                var fillFraction = ratio / Float(colorTresholdForDeltas)
                if fillFraction > 1 {
                    fillFraction = 1
                } else if fillFraction < 0 {
                    fillFraction = 0
                }
                let entry = complication.getTimelineEntry(fillFraction: fillFraction, latestMeasurement: latest)
                handler(entry)
            case .failure(_):
                handler(nil)
            }
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        getCurrentTimelineEntry(for: complication) { entry in
            if let entry = entry {
                handler([entry])
            } else {
                handler(nil)
            }
        }
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
