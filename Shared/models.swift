//
//  models.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

struct CountryMeasurement: Decodable, Equatable {
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
