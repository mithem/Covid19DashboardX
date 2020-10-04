//
//  models.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import SwiftUI

// MARK: Models for summary (decoding & using)

struct CountrySummaryMeasurement: Decodable, Equatable, Identifiable, SummaryProvider {
    
    var id: String { countryCode }
    let country: String
    let countryCode: String
    let date: Date
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let slug: String?
    
    init(country: String, countryCode: String, date: Date, totalConfirmed: Int, newConfirmed: Int, totalDeaths: Int, newDeaths: Int, totalRecovered: Int, newRecovered: Int, slug: String? = nil) {
        self.country = country
        self.countryCode = countryCode
        self.date = date
        self.totalConfirmed = totalConfirmed
        self.newConfirmed = newConfirmed
        self.totalDeaths = totalDeaths
        self.newDeaths = newDeaths
        self.totalRecovered = totalRecovered
        self.newRecovered = newRecovered
        self.slug = slug
    }
    
    /// Calculate textual representations of measurements
    /// - Returns: stats
    /// - Parameter stats: statistics to get
    ///
    /// Order: [country, countryCode, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, date, slug]
    func getStats(_ stats: [MeasurementMetric]) -> [String] {
        var result = [String]()
        var c = false
        var cc = false
        var tC = false
        var nC = false
        var tD = false
        var nD = false
        var tR = false
        var nR = false
        var d = false
        var s = false
        
        for stat in stats {
            switch stat {
            case .country:
                c = true
            case .countryCode:
                cc = true
            case .date:
                d = true
            case .totalConfirmed:
                tC = true
            case .newConfirmed:
                nC = true
            case .totalDeaths:
                tD = true
            case .newDeaths:
                nD = true
            case .totalRecovered:
                tR = true
            case .newRecovered:
                nR = true
            case .slug:
                s = true
            }
        }
        
        if c {
            result.append(country)
        }
        if cc {
            result.append(countryCode)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        
        if tC {
            result.append(numberFormatter.string(from: NSNumber(value: totalConfirmed)) ?? notAvailableString)
        }
        if nC {
            result.append(numberFormatter.string(from: NSNumber(value: newConfirmed)) ?? notAvailableString)
        }
        if tD {
            result.append(numberFormatter.string(from: NSNumber(value: totalDeaths)) ?? notAvailableString)
        }
        if nD {
            result.append(numberFormatter.string(from: NSNumber(value: newDeaths)) ?? notAvailableString)
        }
        if tR {
            result.append(numberFormatter.string(from: NSNumber(value: totalRecovered)) ?? notAvailableString)
        }
        if nR {
            result.append(numberFormatter.string(from: NSNumber(value: newRecovered)) ?? notAvailableString)
        }
        
        if d {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            result.append(dateFormatter.string(from: date))
        }
        
        if s {
            result.append(slug ?? notAvailableString)
        }
        
        return result
    }
    
    static func ==(_ lhs: CountrySummaryMeasurement, _ rhs: CountrySummaryMeasurement) -> Bool {
        let c = lhs.country == rhs.country
        let cc = lhs.countryCode == rhs.countryCode
        let d = lhs.date == rhs.date
        let tC = lhs.totalConfirmed == rhs.totalConfirmed
        let nC = lhs.newConfirmed == rhs.newConfirmed
        let tD = lhs.totalDeaths == rhs.totalDeaths
        let nD = lhs.newDeaths == rhs.newDeaths
        let tR = lhs.totalRecovered == rhs.totalRecovered
        let nR = lhs.newRecovered == rhs.newRecovered
        let s = lhs.slug == rhs.slug
        
        return c && cc && d && tC && nC && tD && nD && tR && nR && s
    }
}

struct GlobalMeasurement: Decodable, Equatable, SummaryProvider {
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
}

struct SummaryResponse: Decodable, Equatable {
    let global: GlobalMeasurement
    let countries: [CountrySummaryMeasurement]
    let date: Date
}

protocol SummaryProvider {
    var totalConfirmed: Int { get }
    var newConfirmed: Int { get }
    var totalDeaths: Int { get }
    var newDeaths: Int { get }
    var totalRecovered: Int { get }
    var newRecovered: Int { get }
    
    var confirmedSummary: Text { get }
    var deathsSummary: Text { get }
    var recoveredSummary: Text { get }
    
    func summary(total: Int, new: Int) -> Text
    func summaryFor(metric: SummaryViewMetric) -> Text
}

extension SummaryProvider {
    func summary(total: Int, new: Int) -> Text {
        let colorNumbers = UserDefaults().bool(forKey: UserDefaultsKeys.colorNumbers)
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        let sign = new > 0 ? "+" : (new < 0 ? "-" : "=")
        let t1 = Text("\(numberFormatter.string(from: NSNumber(value: total)) ?? notAvailableString) (")
        let t2 = Text("\(sign)\(numberFormatter.string(from: NSNumber(value: new)) ?? notAvailableString)")
        let t3 = Text(")")
        if colorNumbers {
            return t1 + t2.foregroundColor(new > 0 ? .red : (new < 0 ? .green : .gray)) + t3
        }
        return t1 + t2 + t3
    }
    
    var confirmedSummary: Text {
        return summary(total: totalConfirmed, new: newConfirmed)
    }
    var deathsSummary: Text {
        return summary(total: totalDeaths, new: newDeaths)
    }
    var recoveredSummary: Text {
        return summary(total: totalRecovered, new: newRecovered)
    }
    
    func summaryFor(metric: SummaryViewMetric) -> Text {
        switch metric {case .confirmed:
            return confirmedSummary
        case .deaths:
            return deathsSummary
        case .recovered:
            return recoveredSummary
        }
    }
}

enum MeasurementMetric {
    case country
    case countryCode
    case date
    case totalConfirmed
    case newConfirmed
    case totalDeaths
    case newDeaths
    case totalRecovered
    case newRecovered
    case slug
}

enum SummaryViewMetric: String {
    case confirmed = "confirmed"
    case deaths = "deaths"
    case recovered = "recovered"
}

// MARK: Models for decoding country history

struct CountryHistoryMeasurementForDecodingOnly: Decodable {
    var cases: Int?
    var confirmed: Int?
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var date: Date
    var status: CountryHistoryMeasurementStatusMetric?
    var country: String
    var countryCode: String
    var lat: String
    var lon: String
}

// MARK: Models for later use

class Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        let c = lhs.code == rhs.code
        let n = lhs.name == rhs.name
        let m = lhs.measurements == rhs.measurements
        
        return c && n && m
    }
    // No struct, so it passes by reference
    let id: UUID
    var code: String
    var name: String
    var measurements: [CountryHistoryMeasurement]
    
    init(code: String, name: String, measurements: [CountryHistoryMeasurement]) {
        self.id = UUID()
        self.code = code
        self.name = name
        self.measurements = measurements
    }
}

enum CountryHistoryMeasurementStatusMetric: String, Decodable {
    case confirmed = "confirmed"
    case deaths = "deaths"
    case recovered = "recovered"
}

struct CountryHistoryMeasurement: Equatable {
    var confirmed: Int
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var date: Date
    var status: CountryHistoryMeasurementStatusMetric
}
