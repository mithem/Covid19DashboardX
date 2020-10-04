//
//  models.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

struct CountryMeasurement: Decodable, Equatable, Identifiable, SummaryProvider {
    
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
    /// Order: [country, countryCode, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, date, slug]
    func getStats(_ stats: [MeasureableRelevantParameters]) -> [String] {
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
    
    enum MeasureableRelevantParameters {
        case country, countryCode, date, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered, slug
    }
    
    static func ==(_ lhs: CountryMeasurement, _ rhs: CountryMeasurement) -> Bool {
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

struct Response: Decodable, Equatable {
    let global: GlobalMeasurement
    let countries: [CountryMeasurement]
    let date: Date
}

protocol SummaryProvider {
    var totalConfirmed: Int { get }
    var newConfirmed: Int { get }
    var confirmedSummary: String { get }
}

extension SummaryProvider {
    var confirmedSummary: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        let sign = newConfirmed > 0 ? "+" : (newConfirmed < 0 ? "-" : "=")
        return "\(numberFormatter.string(from: NSNumber(value: totalConfirmed)) ?? notAvailableString) (\(sign)\(numberFormatter.string(from: NSNumber(value: newConfirmed)) ?? notAvailableString))"
    }
}
