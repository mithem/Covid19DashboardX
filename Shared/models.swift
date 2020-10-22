//
//  models.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation
import SwiftUI

// MARK: Models for summary (decoding & using)

struct CountrySummaryMeasurementForDecodingOnly: Decodable, Equatable, Identifiable {
    
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
    let active: Int?
    let newActive: Int?
    let caseFatalityRate: Double?
    let slug: String?
    
    init(country: String, countryCode: String, date: Date, totalConfirmed: Int, newConfirmed: Int, totalDeaths: Int, newDeaths: Int, totalRecovered: Int, newRecovered: Int, slug: String? = nil, active: Int? = nil, newActive: Int? = nil, caseFatalityRate: Double?) {
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
        self.active = active
        self.newActive = newActive
        self.caseFatalityRate = caseFatalityRate
    }
    
    static func ==(_ lhs: CountrySummaryMeasurementForDecodingOnly, _ rhs: CountrySummaryMeasurementForDecodingOnly) -> Bool {
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

struct SummaryResponse: Decodable, Equatable {
    let global: GlobalMeasurement
    let countries: [CountrySummaryMeasurementForDecodingOnly]
    let date: Date
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
    case active
    case caseFatalityRate
    case slug
}

// MARK: Models for decoding country history

struct CountryHistoryMeasurementForDecodingOnly: Decodable {
    var cases: Int?
    var confirmed: Int?
    var deaths: Int?
    var recovered: Int?
    var active: Int
    var caseFatalityRate: Int?
    var date: Date
    var status: BasicMeasurementMetric?
    var country: String
    var countryCode: String
    var lat: String
    var lon: String
}

// MARK: Models for later use

enum BasicMeasurementMetric: String, Decodable, CaseIterable, Identifiable {
    var id: BasicMeasurementMetric { self }
    
    case confirmed = "confirmed"
    case deaths = "deaths"
    case recovered = "recovered"
    case active = "active"
    case caseFatalityRate = "case fatality rate"
    
    var humanReadable: String {
        switch self {
        case .confirmed:
            return "Confirmed cases"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        case .active:
            return "Active cases"
        case .caseFatalityRate:
            return "Case fatality rate"
        }
    }
}

struct CountrySummaryMeasurement {
    let date: Date
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let active: Int?
    let newActive: Int?
    let caseFatalityRate: Double?
}

class Country: SummaryProvider {
    var totalConfirmed: Int { latest.totalConfirmed }
    var newConfirmed: Int { latest.newConfirmed }
    var totalDeaths: Int { latest.totalDeaths }
    var newDeaths: Int { latest.newDeaths }
    var totalRecovered: Int { latest.totalRecovered }
    var newRecovered: Int { latest.newRecovered }
    var active: Int { latest.active ?? totalConfirmed - totalRecovered - totalDeaths }
    var newActive: Int? { latest.newActive }
    var caseFatalityRate: Double? { latest.caseFatalityRate }
    
    var code: String
    var name: String
    var latest: CountrySummaryMeasurement
    var measurements: [CountryHistoryMeasurement]
    
    init(code: String, name: String, latest: CountrySummaryMeasurement, measurements: [CountryHistoryMeasurement] = []) {
        self.code = code
        self.name = name
        self.latest = latest
        self.measurements = measurements
    }
}

struct CountryHistoryMeasurement {
    var confirmed: Int
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var date: Date
    var caseFatalityRate: Int?
    
    func metric(for basicMetric: BasicMeasurementMetric) -> Int {
        switch basicMetric {
        case .confirmed:
            return confirmed
        case .deaths:
            return deaths ?? -1
        case .recovered:
            return recovered ?? -1
        case .active:
            return active ?? -1
        case .caseFatalityRate:
            return caseFatalityRate ?? -1
        }
    }
}

struct GlobalMeasurement: Decodable, Equatable, SummaryProvider {
    
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let active: Int
    let caseFatalityRate: Double?
}

// MARK: SummaryProvider
protocol SummaryProvider {
    var totalConfirmed: Int { get }
    var newConfirmed: Int { get }
    var totalDeaths: Int { get }
    var newDeaths: Int { get }
    var totalRecovered: Int { get }
    var newRecovered: Int { get }
    var active: Int { get }
    var caseFatalityRate: Double? { get }
    
    func confirmedSummary(colorNumbers: Bool) -> Text
    func deathsSummary(colorNumbers: Bool) -> Text
    func recoveredSummary(colorNumbers: Bool) -> Text
    func activeSummary(colorNumbers: Bool) -> Text
    func cfrSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
    
    func summary(total: Int, new: Int?, colorNumbers: Bool) -> Text
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text
}

extension SummaryProvider {
    func summary(total: Int, new: Int?, colorNumbers: Bool) -> Text {
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
    
    func confirmedSummary(colorNumbers: Bool) -> Text {
        return summary(total: totalConfirmed, new: newConfirmed, colorNumbers: colorNumbers)
    }
    func deathsSummary(colorNumbers: Bool) -> Text {
        return summary(total: totalDeaths, new: newDeaths, colorNumbers:    colorNumbers)
    }
    func recoveredSummary(colorNumbers: Bool) -> Text {
        return summary(total: totalRecovered, new: newRecovered, colorNumbers: colorNumbers)
    }
    func activeSummary(colorNumbers: Bool) -> Text {
        return summary(total: active, new: nil, colorNumbers: colorNumbers)
    }
    func cfrSummary(colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        return summary(percentage: caseFatalityRate, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
    }
    
    func summaryFor(metric: BasicMeasurementMetric, colorNumbers: Bool, colorTreshold: Double, colorGrayArea: Double, reversed: Bool) -> Text {
        switch metric {
        case .confirmed:
            return confirmedSummary(colorNumbers: colorNumbers)
        case .deaths:
            return deathsSummary(colorNumbers: colorNumbers)
        case .recovered:
            return recoveredSummary(colorNumbers: colorNumbers)
        case .active:
            return activeSummary(colorNumbers: colorNumbers)
        case .caseFatalityRate:
            return cfrSummary(colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: reversed)
        }
    }
}

enum DataRepresentationType: String, CaseIterable, Identifiable {
    var id: DataRepresentationType { self }
    
    case normal = "normal"
    case quadratic = "quadratic"
    case sqRoot = "square root"
    case logarithmic = "logarithmic"
}

// MARK: Errors

enum NetworkError: Error, Equatable, LocalizedError {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {lhs.localizedDescription == rhs.localizedDescription} // no better way?
    
    case invalidResponse
    case noResponse // don't actually know whether that can happen without a timeout error 🤔
    case urlError(_ error: URLError)
    case noNetworkConnection
    case constrainedNetwork
    case otherWith(error: Error)
    case other
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .noResponse:
            return "No response from server."
        case .urlError(let error):
            return error.localizedDescription
        case .noNetworkConnection:
            return "No network connection."
        case .constrainedNetwork:
            return "Low data mode is on."
        case .otherWith(error: let error):
            return error.localizedDescription
        case .other:
            return "Unkown."
        }
    }
}

// MARK: Extensions

extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        let c = lhs.code == rhs.code
        let n = lhs.name == rhs.name
        let m = lhs.measurements == rhs.measurements
        
        return c && n && m
    }
}

extension Country: Identifiable {
    var id: String { code }
}

extension CountryHistoryMeasurement: Equatable {}

extension CountryHistoryMeasurement: Identifiable {
    var id: Date { date }
}
