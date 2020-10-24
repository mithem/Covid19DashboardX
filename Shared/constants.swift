//
//  constants.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import Foundation

let notAvailableString = "N/A"

struct UserDefaultsKeys {
    static let activeMetric = "activeMetric"
    static let provinceMetric = "provinceMetric"
    static let colorNumbers = "colorNumbers"
    static let dataRepresentationType = "dataRepresentationType"
    static let maximumN = "maximumMovingAverage"
    static let currentN = "currentN"
    static let colorThresholdForPercentages = "colorThresholdForPercentages"
    static let colorGrayAreaForPercentages = "colorGrayAreaForPercentages"
    static let caseFatalityRateGreenTreshold = "caseFatalityRateGreenTreshold"
    static let caseFatalityRateRedTreshold = "caseFatalityRateRedTreshold"
}

struct DefaultSettings {
    static let colorNumbers = false
    static let measurementMetric = BasicMeasurementMetric.confirmed
    static let provinceMetric = Province.SummaryMetric.confirmed
}

let covidDashApiDotComDateFormat = "YYYY-mm-DD"

let countriesForPreviews = [Country(code: "US", name: "United States", latest: CountrySummaryMeasurement(date: Date() + 259_200, totalConfirmed: 200, newConfirmed: 50, totalDeaths: 18, newDeaths: 10, totalRecovered: 100, newRecovered: 30, active: 5, newActive: 2, caseFatalityRate: 0.005), measurements: [CountryHistoryMeasurement(confirmed: 100, deaths: 2, recovered: 20, active: 10, date: Date()), CountryHistoryMeasurement(confirmed: 120, deaths: 4, recovered: 35, active: 15, date: Date() + 86_400), CountryHistoryMeasurement(confirmed: 150, deaths: 8, recovered: 70, active: 20, date: Date() + 192_800)], provinces: [Province(name: "Washington", measurements: [ProvinceMeasurement(date: Date(), totalConfirmed: 5, newConfirmed: 6, totalRecovered: 7, newRecovered: 8, totalDeaths: 9, newDeaths: 10, active: 11, newActive: 12, caseFatalityRate: 0.005)])]), Country(code: "empty", name: "Empty country", latest: CountrySummaryMeasurement(date: Date(), totalConfirmed: 0, newConfirmed: 0, totalDeaths: 0, newDeaths: 0, totalRecovered: 0, newRecovered: 0, active: 10, newActive: 4, caseFatalityRate: 0.005))]

let dataForPreviews = [[3, 7, 32, 1, 4, 7, 8, 45, 2, 1, 45, 6, 23], [45, 78, 105, 120, 120, 50, 584, 920, 458, 1050]].map {$0.map {Double($0)}}

struct SpecialCountries {
    static let emptyCountry = countriesForPreviews[1]
}

struct UsefulURLs {
    static let whoCovid19AdviceForPublic = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public")!
}

/// A dictionary mapping ISO Alpha2 country-codes to Alpha3 ones
/// https://stackoverflow.com/questions/11576947/ios-convert-iso-alpha-2-to-alpha-3-country-code
let alpha2_to_alpha3_countryCodes = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "ISO_CountryCodes", ofType: "plist")!)!
