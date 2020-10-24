//
//  SummaryProvider.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 24.10.20.
//

import Foundation
import SwiftUI

protocol SummaryProvider {
    var totalConfirmed: Int { get }
    var newConfirmed: Int { get }
    var totalDeaths: Int { get }
    var newDeaths: Int { get }
    var totalRecovered: Int { get }
    var newRecovered: Int { get }
    var activeCases: Int? { get }
    var caseFatalityRate: Double? { get }
    
    func confirmedSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func deathsSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func recoveredSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func activeSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func cfrSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    
    func summary(total: Int?, new: Int?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func summary(total: Int, new: Int?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func summary(percentage: Double?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    func summaryFor(metric: Province.SummaryMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
}

extension SummaryProvider {
    func summary(total: Int, new: Int?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        let colorNumbers = UserDefaults().bool(forKey: UserDefaultsKeys.colorNumbers)
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        if let new = new {
            let sign = new > 0 ? "+" : (new < 0 ? "-" : "=")
            let t1 = Text("\(numberFormatter.string(from: NSNumber(value: total)) ?? notAvailableString) (")
            let t2 = Text("\(sign)\(numberFormatter.string(from: NSNumber(value: new)) ?? notAvailableString)")
            let t3 = Text(")")
            if colorNumbers {
                return t1 + t2.foregroundColor(new > 0 ? .red : (new < 0 ? .green : .gray)) + t3
            }
            return t1 + t2 + t3
        } else {
            return Text(numberFormatter.string(from: NSNumber(value: total)) ?? notAvailableString)
        }
    }
    
    func summary(total: Int?, new: Int?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        guard let toTal = total else { return Text(notAvailableString) }
        return summary(total: toTal, new: new, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    
    func summary(percentage: Double?, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        guard let perCent = percentage else { return Text(notAvailableString) }
        let perCentString = PercentageFormatter().string(from: NSNumber(value: perCent)) ?? notAvailableString
        let text = Text(perCentString)
        var color: Color
        
        if perCent < colorTreshold - colorGrayArea {
            color = .green
        } else if perCent > colorTreshold + colorGrayArea {
            color = .red
        } else {
            color = .gray
        }
        
        switch color {
        case .green:
            return reversed ? text.foregroundColor(.red) : text.foregroundColor(.green)
        case .red:
            return reversed ? text.foregroundColor(.green) : text.foregroundColor(.red)
        case .gray:
            return text.foregroundColor(.gray)
        default:
            return text
        }
    }
    
    func confirmedSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalConfirmed, new: newConfirmed, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    func deathsSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalDeaths, new: newDeaths, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    func recoveredSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalRecovered, new: newRecovered, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    func activeSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: activeCases, new: nil, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    func cfrSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(percentage: caseFatalityRate, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        switch metric {
        case .confirmed:
            return confirmedSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .deaths:
            return deathsSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .recovered:
            return recoveredSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .active:
            return activeSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        }
    }
    
    func summaryFor(metric: Province.SummaryMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        switch metric {
        case .confirmed:
            return confirmedSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .recovered:
            return recoveredSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .deaths:
            return deathsSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .active:
            return activeSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        case .caseFatalityRate:
            return cfrSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        }
    }
}
