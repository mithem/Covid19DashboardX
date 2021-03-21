//
//  shared.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import WatchConnectivity
#if !os(watchOS)
import CoreSpotlight
#endif

func getData(_ data: [Double], dataRepresentation: DataRepresentationType) -> [Double] {
    func appropriateFunction(_ y: Double) -> Double {
        switch dataRepresentation {
        case .normal:
            return y
        case .quadratic:
            return _quadratic(value: y)
        case .sqRoot:
            return _sqRoot(value: y)
        case .logarithmic:
            return _logarithmic(value: y)
        }
    }
    let values = data.map {appropriateFunction($0)}
    return values
}

func _quadratic(value: Double) -> Double {value * value}
func _sqRoot(value: Double) -> Double {sqrt(value)}
func _logarithmic(value: Double) -> Double {
    let v = log(value)
    if v == -1 * .infinity { return 0 }
    return v
}

func resetSettingsToDefaults() {
    let ud = UserDefaults()
    
    typealias uk = UserDefaultsKeys
    typealias ds = DefaultSettings
    
    ud.set(ds.colorNumbers, forKey: uk.colorNumbers)
    ud.set(ds.measurementMetric.rawValue, forKey: uk.measurementMetric)
    ud.set(ds.provinceMetric.rawValue, forKey: uk.provinceMetric)
    ud.set(ds.maximumN, forKey: uk.maximumN)
    ud.set(ds.maximumEstimationInterval, forKey: uk.maximumEstimationInterval)
    ud.set(ds.ignoreLowDataMode, forKey: uk.ignoreLowDataMode)
    ud.set(ds.colorTresholdForPercentages, forKey: uk.colorThresholdForPercentages)
    ud.set(ds.colorGrayAreaForPercentages, forKey: uk.colorGrayAreaForPercentages)
    ud.set(ds.colorTresholdForDeltas, forKey: uk.colorTresholdForDeltas)
    ud.set(ds.colorGrayAreaForDeltas, forKey: uk.colorGrayAreaForDeltas)
    ud.set(ds.widgetCountry, forKey: uk.widgetCountry)
    ud.set(ds.disableSpotlightIndexing, forKey: uk.disableSpotlightIndexing)
    ud.set(ds.notificationsEnabled, forKey: uk.notificationsEnabled)
    ud.set(ds.notificationDate, forKey: uk.notificationDate)
    ud.set(ds.dataRepresentationType.rawValue, forKey: uk.dataRepresentationType)
}

#if !os(watchOS)
func indexForSpotlight(countries: [Country]) {
    var items = [CSSearchableItem]()
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    let dateString = " (\(formatter.string(from: Date())))"
    let index = CSSearchableIndex.default()
    
    var identifiers = [String]()
    for country in countries {
        identifiers.append(country.code)
        for province in country.provinces {
            identifiers.append("\(country.id)-\(province.id)")
        }
    }
    
    index.deleteSearchableItems(withIdentifiers: identifiers) { error in
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if !UserDefaults().bool(forKey: UserDefaultsKeys.disableSpotlightIndexing) {
            for country in countries {
                
                let set = CSSearchableItemAttributeSet(contentType: .content)
                set.title = country.name.localizedCapitalized
                set.contentDescription = country.summaryFor(metric: .confirmed) + dateString
                
                let item = CSSearchableItem(uniqueIdentifier: country.id, domainIdentifier: country.id, attributeSet: set)
                items.append(item)
                
                for province in country.provinces {
                    
                    let set = CSSearchableItemAttributeSet(contentType: .content)
                    set.title = province.name.localizedCapitalized
                    set.contentDescription = province.summaryFor(metric: .confirmed) + dateString
                    
                    let item = CSSearchableItem(uniqueIdentifier: "\(country.id)-\(province.id)", domainIdentifier: country.code, attributeSet: set)
                    items.append(item)
                    
                }
            }
            
            index.indexSearchableItems(items) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

func indexGlobalMeasurementForSpotlight(_ measurement: GlobalMeasurement) {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    let dateString = " (\(formatter.string(from: Date())))"
    let index = CSSearchableIndex.default()
    
    let nameAndIdentifier = "Global"
    
    let set = CSSearchableItemAttributeSet(contentType: .content)
    set.title = nameAndIdentifier
    set.contentDescription = measurement.summaryFor(metric: .confirmed) + dateString
    let item = CSSearchableItem(uniqueIdentifier: nameAndIdentifier, domainIdentifier: nil, attributeSet: set)
    
    index.deleteSearchableItems(withIdentifiers: [nameAndIdentifier]) { error in
        if let error = error {
            print(error.localizedDescription)
        }
        
        if !UserDefaults().bool(forKey: UserDefaultsKeys.disableSpotlightIndexing) {
            index.indexSearchableItems([item]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

@available(iOS 14, *)
func deleteIndexForSpotlight(completion: @escaping (Error?) -> Void) {
    let index = CSSearchableIndex.default()
    index.deleteAllSearchableItems(completionHandler: completion)
}
#endif

func calculateDoublingRate(new: Int, total: Int, in days: Int) -> Double {
    guard new >= 0 else { return .nan }
    if new == 0 { return .infinity }
    let ratio = (Double(new) / Double(total)) / Double(days)
    let growthFactor = 1 + ratio
    let days = ln(2) / ln(growthFactor)
    return days
}

func calculateHalvingTime(new: Int, total: Int, in days: Int) -> Double {
    guard new <= 0 else { return .nan }
    if new == 0 { return .infinity }
    let ratio = (Double(new) / Double(total)) / Double(days) // negative
    let growthFactor = 1 + ratio
    let days = ln(0.5) / ln(growthFactor)
    return days
}

/// Based on the given numbers, either calculate the case doubling time or halving time, assuming the change is exponential.
func calculateExponentialProperty(new: Int, total: Int, in days: Int) -> ExponentialProperty {
    if new == 0 {
        return .none
    }
    if new > 0 {
        return .doublingTime(calculateDoublingRate(new: new, total: total, in: days))
    } else {
        return .halvingTime(calculateHalvingTime(new: new, total: total, in: days))
    }
}

/// natural log
func ln(_ value: Double) -> Double {
    return log(value) / log(Double.eulersNumber)
}
