//
//  shared.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

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
    ud.set(DefaultSettings.colorNumbers, forKey: uk.colorNumbers)
    ud.set(DefaultSettings.measurementMetric.rawValue, forKey: uk.activeMetric)
    ud.set(DefaultSettings.provinceMetric.rawValue, forKey: uk.provinceMetric)
    ud.set(DefaultSettings.maximumN, forKey: uk.maximumN)
    ud.set(DefaultSettings.ignoreLowDataMode, forKey: uk.ignoreLowDataMode)
    ud.set(DefaultSettings.colorTresholdForPercentages, forKey: uk.colorThresholdForPercentages)
    ud.set(DefaultSettings.colorGrayAreaForPercentages, forKey: uk.colorGrayAreaForPercentages)
}
