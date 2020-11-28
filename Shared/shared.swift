//
//  shared.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import CoreSpotlight

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
    ud.set(ds.measurementMetric.rawValue, forKey: uk.activeMetric)
    ud.set(ds.provinceMetric.rawValue, forKey: uk.provinceMetric)
    ud.set(ds.maximumN, forKey: uk.maximumN)
    ud.set(ds.ignoreLowDataMode, forKey: uk.ignoreLowDataMode)
    ud.set(ds.colorTresholdForPercentages, forKey: uk.colorThresholdForPercentages)
    ud.set(ds.colorGrayAreaForPercentages, forKey: uk.colorGrayAreaForPercentages)
    ud.set(ds.widgetCountry, forKey: uk.widgetCountry)
    ud.set(ds.absoluteNumbersDeltaTresholdProportion, forKey: uk.absoluteNumbersDeltaTresholdProportion)
    ud.set(ds.absoluteNumbersDeltaGrayAreaProportion, forKey: uk.absoluteNumbersDeltaGrayAreaProportion)
}

func indexForSpotlight(countries: [Country], global: GlobalMeasurement?) {
    var items = [CSSearchableItem]()
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    let dateString = " (\(formatter.string(from: Date())))"
    let index = CSSearchableIndex.default()
    
    let globalIdentifierAndName = "Global"
    
    var identifiers = [globalIdentifierAndName]
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
            if let global = global {
                let set = CSSearchableItemAttributeSet(contentType: .content)
                set.title = globalIdentifierAndName
                set.contentDescription = global.summaryFor(metric: .confirmed) + dateString
                let item = CSSearchableItem(uniqueIdentifier: globalIdentifierAndName, domainIdentifier: nil, attributeSet: set)
                items.append(item)
            }
            
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

func deleteIndexForSpotlight(completion: @escaping (Error?) -> Void) {
    let index = CSSearchableIndex.default()
    index.deleteAllSearchableItems(completionHandler: completion)
}
