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

// MARK: Models for decoding provinces

/// A response when requesting (current) data for all provinces of a country
struct CountryProvincesResponse: Codable {
    let data: [ProvinceMeasurementForDecodingOnly]
}

struct ProvinceMeasurementForDecodingOnly: Codable {
    let date: Date
    let confirmed: Int
    let confirmedDiff: Int
    let deaths: Int
    let deathsDiff: Int
    let recovered: Int
    let recoveredDiff: Int
    let active: Int
    let activeDiff: Int
    let fatalityRate: Double
    let region: ProvinceMeasurementRegionForDecodingOnly
}

struct ProvinceMeasurementRegionForDecodingOnly: Codable {
    let iso: String
    let name: String
    let province: String
    let lat: String?
    let long: String?
}

// MARK: Models for decoding detailed country measurements (snapshots)

struct DetailedCountryMeasurementContainerForDecodingOnly: Decodable {
    let data: DetailedCountryMeasurementForDecodingOnly
}

struct DetailedCountryMeasurementForDecodingOnly: Decodable {
    let date: Date
    let confirmed: Int
    let confirmedDiff: Int
    let recovered: Int
    let recoveredDiff: Int
    let deaths: Int
    let deathsDiff: Int
    let active: Int
    let activeDiff: Int
    let fatalityRate: Double
}

// MARK: Models for later use

enum BasicMeasurementMetric: String, Decodable, CaseIterable, Identifiable {
    var id: BasicMeasurementMetric { self }
    
    case confirmed = "confirmed"
    case deaths = "deaths"
    case recovered = "recovered"
    case active = "active"
    
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
        }
    }
    
    var shortDescription: String {
        switch self {
        case .confirmed:
            return "Confirmed"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        case .active:
            return "Active"
        }
    }
}

struct CountrySummaryMeasurement {
    var date: Date
    var totalConfirmed: Int
    var newConfirmed: Int
    var totalDeaths: Int
    var newDeaths: Int
    var totalRecovered: Int
    var newRecovered: Int
    var active: Int?
    var newActive: Int?
    var caseFatalityRate: Double?
}

class Country: SummaryProvider {
    var totalConfirmed: Int { latest.totalConfirmed }
    var newConfirmed: Int { latest.newConfirmed }
    var totalDeaths: Int { latest.totalDeaths }
    var newDeaths: Int { latest.newDeaths }
    var totalRecovered: Int { latest.totalRecovered }
    var newRecovered: Int { latest.newRecovered }
    var activeCases: Int? { latest.active ?? totalConfirmed - totalRecovered - totalDeaths}
    var newActive: Int? { latest.newActive }
    var caseFatalityRate: Double? { latest.caseFatalityRate }
    var provinces: [Province]
    
    var code: String
    var name: String
    var latest: CountrySummaryMeasurement
    var measurements: [CountryHistoryMeasurement]
    
    init(code: String, name: String, latest: CountrySummaryMeasurement, measurements: [CountryHistoryMeasurement] = [], provinces: [Province] = []) {
        self.code = code
        self.name = name
        self.latest = latest
        self.measurements = measurements
        self.provinces = provinces
    }
}

struct Province: SummaryProvider {
    var name: String
    var totalConfirmed: Int { measurements.last?.totalConfirmed ?? 0 }
    var newConfirmed: Int { measurements.last?.newConfirmed ?? 0 }
    var totalDeaths: Int { measurements.last?.totalDeaths ?? 0 }
    var newDeaths: Int { measurements.last?.newDeaths ?? 0 }
    var totalRecovered: Int { measurements.last?.totalRecovered ?? 0 }
    var newRecovered: Int { measurements.last?.newRecovered ?? 0 }
    var activeCases: Int? { measurements.last?.active }
    var newActive: Int? { measurements.last?.newActive }
    var caseFatalityRate: Double? { measurements.last?.caseFatalityRate }
    
    var measurements: [ProvinceMeasurement]
    
    enum Metric: CaseIterable, Identifiable {
        var id: Metric { self }
        case active, newActive, totalConfirmed, newConfirmed, totalRecovered, newRecovered, totalDeaths, newDeaths, caseFatalityRate
        
        var humanReadable: String {
            switch self {
            case .active:
                return "Active"
            case .newActive:
                return "New active"
            case .totalConfirmed:
                return "Total confirmed"
            case .newConfirmed:
                return "New confirmed"
            case .totalRecovered:
                return "Total recovered"
            case .newRecovered:
                return "New recovered"
            case .totalDeaths:
                return "Total deaths"
            case .newDeaths:
                return "New deaths"
            case .caseFatalityRate:
                return "Case fatality rate"
            }
        }
    }
    
    func value(for metric: Metric) -> String {
        var v: Any
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
        }
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        if let v = v as? Int {
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: v)) ?? notAvailableString
        } else if let v = v as? Double {
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 5
            return formatter.string(from: NSNumber(value: v)) ?? notAvailableString
        } else {
            return notAvailableString
        }
    }
    
    enum SummaryMetric: String, CaseIterable, Identifiable {
        var id: SummaryMetric { self }
        case confirmed, recovered, deaths, active, caseFatalityRate
        
        var short: String {
            switch self {
            case .confirmed:
                return "Confirmed"
            case .recovered:
                return "Recovered"
            case .deaths:
                return "Deaths"
            case .active:
                return "Active"
            case .caseFatalityRate:
                return "CFR"
            }
        }
    }
}

struct ProvinceMeasurement {
    var date: Date
    var totalConfirmed: Int
    var newConfirmed: Int
    var totalRecovered: Int
    var newRecovered: Int
    var totalDeaths: Int
    var newDeaths: Int
    var active: Int
    var newActive: Int
    var caseFatalityRate: Double?
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
    let active: Int?
    let caseFatalityRate: Double?
    
    var activeCases: Int? { active ?? totalConfirmed - totalRecovered - totalDeaths }
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
    
    case invalidResponse(response: String)
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

extension Province: Identifiable {
    var id: String { name }
    
}

extension CountryProvincesResponse: Equatable {
    static func == (lhs: CountryProvincesResponse, rhs: CountryProvincesResponse) -> Bool {lhs.data == rhs.data}
}

extension ProvinceMeasurementForDecodingOnly: Equatable {
    static func == (lhs: ProvinceMeasurementForDecodingOnly, rhs: ProvinceMeasurementForDecodingOnly) -> Bool {
        let a = lhs.active == rhs.active
        let ad = lhs.activeDiff == rhs.activeDiff
        let c = lhs.confirmed == rhs.confirmed
        let cd = lhs.confirmedDiff == rhs.confirmedDiff
        let d = lhs.deaths == rhs.deaths
        let dd = lhs.deathsDiff == rhs.deathsDiff
        let cfr = round(lhs.fatalityRate) == round(rhs.fatalityRate)
        let r = lhs.recovered == rhs.recovered
        let rd = lhs.recoveredDiff == rhs.recoveredDiff
        let re = lhs.region == rhs.region
        
        return a && ad && c && cd && d && dd && cfr && r && rd && re
    }
}

extension ProvinceMeasurementRegionForDecodingOnly: Equatable {}

// MARK: Searchable Extensions

extension Country: Searchable {
    func isIncluded(searchTerm: String) -> Bool {
        if searchTerm.isEmpty { return true }
        return name.lowercased().contains(searchTerm) || searchTerm.contains(code.lowercased())
    }
}

extension Province: Searchable {
    func isIncluded(searchTerm: String) -> Bool {
        if searchTerm.isEmpty { return true }
        return name.lowercased().contains(searchTerm)
    }
}
