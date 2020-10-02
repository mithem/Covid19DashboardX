//
//  models.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

struct CountryMeasurement: Decodable, Equatable, Identifiable, Sequence, IteratorProtocol, RandomAccessCollection {
    
    typealias Element = String
    private var attributes: [String]? = nil
    private var attrIdx: Int? = nil
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
    
    // Don't need this
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
        
        prepareIterator()
    }
    
    mutating func prepareIterator() {
        let notAvailableString = "N/A"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        
        let tConf = numberFormatter.string(from: NSNumber(value: totalConfirmed)) ?? notAvailableString
        let nConf = numberFormatter.string(from: NSNumber(value: newConfirmed)) ?? notAvailableString
        let tDeaths = numberFormatter.string(from: NSNumber(value: totalDeaths)) ?? notAvailableString
        let nDeaths = numberFormatter.string(from: NSNumber(value: newDeaths)) ?? notAvailableString
        let tRecov = numberFormatter.string(from: NSNumber(value: totalRecovered)) ?? notAvailableString
        let nRecov = numberFormatter.string(from: NSNumber(value: newRecovered)) ?? notAvailableString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let textualDate = dateFormatter.string(from: date)
        
        
        attributes = [countryCode, tConf, nConf, tDeaths, nDeaths, tRecov, nRecov, textualDate]
        attrIdx = 0
    }
    
    mutating func next() -> String? {
        if attrIdx ?? attributes?.count ?? 0 >= attributes?.count ?? 0 {
            return nil
        }
        if let attributes = attributes {
            guard let idx = attrIdx else { return nil }
            let element = attributes[idx]
            attrIdx = attrIdx! + 1 // checked on ln 70
            return element
        } else {
            return nil
        }
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

struct GlobalMeasurement: Decodable, Equatable {
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
