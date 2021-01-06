//
//  SummaryProvider.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 24.10.20.
//

import Foundation
import SwiftUI

protocol SummaryProvider: Identifiable, Searchable {
    var id: String { get }
    var totalConfirmed: Int { get }
    var newConfirmed: Int { get }
    var totalDeaths: Int { get }
    var newDeaths: Int { get }
    var totalRecovered: Int { get }
    var newRecovered: Int { get }
    var activeCases: Int? { get }
    var newActive: Int? { get }
    var caseFatalityRate: Double? { get }
    
    /// Used to display in SummaryProviderDetailView
    var description: String { get }
    
    /// Number of days it takes for active cases to double
    var doublingTime: TimeInterval? { get }
    
    func newSummaryElement(metric: BasicMeasurementMetric, colorTresholdForDeltas: Double, colorGrayAreaForDeltas: Double) -> Text
    func newSummaryElement(total: Int, new: Int, colorTresholdForDeltas: Double, colorGrayAreaForDeltas: Double) -> Text
    
    func confirmedSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func deathsSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func recoveredSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func activeSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func cfrSummary(colorNumbers: Bool, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text
    
    func confirmedSummary() -> String
    func deathsSummary() -> String
    func recoveredSummary() -> String
    func activeSummary() -> String
    
    func summary(total: Int?, new: Int?, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func summary(total: Int, new: Int?, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func summary(percentage: Double?, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text
    func summary(double: Double?) -> Text
    
    func summary(total: Int, new: Int?) -> String
    func summary(total: Int?, new: Int?) -> String
    func summary(double: Double?) -> String
    
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text
    func summaryFor(metric: Province.SummaryMetric, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text
    func summaryFor(metric: BasicMeasurementMetric) -> String
    
    func value(for metric: MeasurementMetric) -> String
    func value(for metric: BasicMeasurementMetric, significantDigits: Int) -> String
}

extension SummaryProvider {
    func isIncluded(searchTerm: String) -> Bool {
        return id.contains(searchTerm)
    }
    
    private func reversedColor(_ color: Color, reversed: Bool) -> Color {
        switch color {
        case .green:
            return reversed ? .red : .green
        case .red:
            return reversed ? .green : .red
        case .gray:
            return .gray
        default:
            return color
        }
    }
    
    private func getColor(ratio: Double, treshold: Double, grayArea: Double) -> Color {
        if ratio < treshold - grayArea {
            return .green
        } else if ratio > treshold + grayArea {
            return .red
        } else {
            return .gray
        }
    }
    
    var description: String { Constants.notAvailableString }
    
    var doublingTime: TimeInterval? {
        guard let newActive = newActive else { return nil }
        guard let active = activeCases else { return nil }
        return calculateDoublingRate(new: newActive, total: active, in: 1)
    }
    
    func newSummaryElement(metric: BasicMeasurementMetric, colorTresholdForDeltas: Double, colorGrayAreaForDeltas: Double) -> Text {
        let total: Int?
        let new: Int?
        switch metric {
        case .confirmed:
            total = totalConfirmed
            new = newConfirmed
        case .recovered:
            total = totalRecovered
            new = newRecovered
        case .deaths:
            total = totalDeaths
            new = newDeaths
        case .active:
            total = activeCases
            new = newActive
        }
        guard let t = total, let n = new else { return Text(Constants.notAvailableString) }
        return newSummaryElement(total: t, new: n, colorTresholdForDeltas: colorTresholdForDeltas, colorGrayAreaForDeltas: colorGrayAreaForDeltas)
    }
    
    func newSummaryElement(total: Int, new: Int, colorTresholdForDeltas: Double, colorGrayAreaForDeltas: Double) -> Text {
        let ratio = Double(new) / Double(total)
        return newSummaryElement(new: new, ratio: ratio, colorTresholdForDeltas: colorTresholdForDeltas, colorGrayAreaForDeltas: colorGrayAreaForDeltas)
    }
    
    func newSummaryElement(new: Int, ratio: Double, colorTresholdForDeltas: Double, colorGrayAreaForDeltas: Double) -> Text {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumSignificantDigits = 5
        
        let sign = new > 0 ? "+" : (new < 0 ? "-" : "=")
        var s = "\(sign)\(formatter.string(from: NSNumber(value: new)) ?? Constants.notAvailableString)"
        if new != 0 {
            s += ", \(PercentageFormatter(precision: 2).string(from: NSNumber(value: ratio)) ?? Constants.notAvailableString)"
        }
        return Text(s).foregroundColor(getColor(ratio: ratio, treshold: colorTresholdForDeltas, grayArea: colorGrayAreaForDeltas))
    }
    
    
    func summary(total: Int, new: Int?, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        
        if let new = new {
            let ratio = Double(new) / Double(total)
            let t1 = Text("\(numberFormatter.string(from: NSNumber(value: total)) ?? Constants.notAvailableString) (")
            let t2 = newSummaryElement(new: new, ratio: ratio, colorTresholdForDeltas: colorDeltaTreshold, colorGrayAreaForDeltas: colorDeltaGrayArea)
            let t3 = Text(")")
            if colorNumbers {
                let color = getColor(ratio: ratio, treshold: colorDeltaTreshold, grayArea: colorDeltaGrayArea)
                return t1 + t2.foregroundColor(reversedColor(color, reversed: reversed)) + t3
            }
            
            return t1 + t2 + t3
        } else {
            return Text(numberFormatter.string(from: NSNumber(value: total)) ?? Constants.notAvailableString)
        }
    }
    
    func summary(total: Int?, new: Int?, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        guard let toTal = total else { return Text(Constants.notAvailableString) }
        return summary(total: toTal, new: new, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
    }
    
    func summary(percentage: Double?, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text {
        guard let perCent = percentage else { return Text(Constants.notAvailableString) }
        let perCentString = PercentageFormatter().string(from: NSNumber(value: perCent)) ?? Constants.notAvailableString
        let text = Text(perCentString)
        let color = getColor(ratio: perCent, treshold: colorPercentagesTreshold, grayArea: colorPercentagesGrayArea)
        
        return text.foregroundColor(reversedColor(color, reversed: reversed))
    }
    
    func summary(double: Double?) -> Text {
        guard let d = double else { return Text(Constants.notAvailableString) }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 3
        return Text(formatter.string(from: NSNumber(value: d)) ?? Constants.notAvailableString)
    }
    
    func summary(total: Int, new: Int?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        if let new = new {
            let sign = new > 0 ? "+" : (new < 0 ? "-" : "=")
            let s1 = numberFormatter.string(from: NSNumber(value: total)) ?? Constants.notAvailableString
            let s2 = " (\(sign)\(numberFormatter.string(from: NSNumber(value: new)) ?? Constants.notAvailableString)"
            let s3 = ")"
            return "\(s1)\(s2)\(s3)"
        } else {
            return numberFormatter.string(from: NSNumber(value: total)) ?? Constants.notAvailableString
        }
    }
    
    func summary(total: Int?, new: Int?) -> String {
        guard let total = total else { return Constants.notAvailableString }
        return summary(total: total, new: new)
    }
    
    func summary(double: Double?) -> String {
        guard let d = double else { return Constants.notAvailableString }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: d)) ?? Constants.notAvailableString
    }
    
    func confirmedSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalConfirmed, new: newConfirmed, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
    }
    func deathsSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalDeaths, new: newDeaths,colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
    }
    func recoveredSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: totalRecovered, new: newRecovered, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
    }
    func activeSummary(colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        return summary(total: activeCases, new: nil, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
    }
    func cfrSummary(colorNumbers: Bool, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text {
        return summary(percentage: caseFatalityRate, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorPercentagesGrayArea, reversed: reversed)
    }
    
    func confirmedSummary() -> String {
        return summary(total: totalConfirmed, new: newConfirmed)
    }
    
    func deathsSummary() -> String {
        return summary(total: totalDeaths, new: newDeaths)
    }
    
    func recoveredSummary() -> String {
        return summary(total: totalRecovered, new: newRecovered)
    }
    
    func activeSummary() -> String {
        return summary(total: activeCases, new: nil)
    }
    
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, reversed: Bool) -> Text {
        switch metric {
        case .confirmed:
            return confirmedSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .deaths:
            return deathsSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .recovered:
            return recoveredSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .active:
            return activeSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        }
    }
    
    func summaryFor(metric: Province.SummaryMetric, colorNumbers: Bool, colorDeltaTreshold: Double, colorDeltaGrayArea: Double, colorPercentagesTreshold: Double, colorPercentagesGrayArea: Double, reversed: Bool) -> Text {
        switch metric {
        case .confirmed:
            return confirmedSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .recovered:
            return recoveredSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .deaths:
            return deathsSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .active:
            return activeSummary(colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: reversed)
        case .caseFatalityRate:
            return cfrSummary(colorNumbers: colorNumbers, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorPercentagesGrayArea, reversed: reversed)
        }
    }
    
    func summaryFor(metric: BasicMeasurementMetric) -> String {
        var s: String
        switch metric {
        case .confirmed:
            s = confirmedSummary()
        case .deaths:
            s = deathsSummary()
        case .recovered:
            s = recoveredSummary()
        case .active:
            s = activeSummary()
        }
        s += " \(metric.humanReadable)"
        return s
    }
    
    func value(for metric: MeasurementMetric) -> String {
        var v: Any
        var vIsTimeInterval = false
        switch metric {
        case .active:
            v =  activeCases as Any
        case .newActive:
            v =  newActive as Any
        case .totalConfirmed:
            v =  totalConfirmed
        case .newConfirmed:
            v =  newConfirmed
        case .totalRecovered:
            v =  totalRecovered
        case .newRecovered:
            v =  newRecovered
        case .totalDeaths:
            v =  totalDeaths
        case .newDeaths:
            v =  newDeaths
        case .caseFatalityRate:
            v =  caseFatalityRate as Any
        case .momentaryDoublingTime:
            v = doublingTime as Any
            vIsTimeInterval = true
        }
        let formatter = NumberFormatter()
        if let v = v as? Int {
            formatter.numberStyle = .scientific
            formatter.maximumSignificantDigits = 5
            return formatter.string(from: NSNumber(value: v)) ?? Constants.notAvailableString
        } else if vIsTimeInterval, let v = v as? TimeInterval{
            return v.shortDescription
        } else if let v = v as? Double {
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 5
            return formatter.string(from: NSNumber(value: v)) ?? Constants.notAvailableString
        } else {
            return Constants.notAvailableString
        }
    }
    
    func value(for metric: BasicMeasurementMetric, significantDigits: Int = 5) -> String {
        let value: NSNumber?
        switch metric {
        case .confirmed:
            value = totalConfirmed as NSNumber
        case .deaths:
            value = totalDeaths as NSNumber
        case .recovered:
            value = totalRecovered as NSNumber
        case .active:
            value = activeCases as NSNumber?
        }
        guard let v = value else { return Constants.notAvailableString }
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumSignificantDigits = significantDigits
        return formatter.string(from: v) ?? Constants.notAvailableString
    }
}
