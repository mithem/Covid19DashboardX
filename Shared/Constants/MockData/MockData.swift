//
//  MockData.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

struct MockData {
    private static let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2020, month: 1, day: 1, hour: 0, minute: 12, second: 5))!
    static let summaryResponse = SummaryResponse(message: "", countries: [CountrySummaryMeasurementForDecodingOnly(country: "Some country", countryCode: "SC", totalConfirmed: 20, newConfirmed: 1, totalDeaths: 1, newDeaths: 0, totalRecovered: 10, newRecovered: 1, caseFatalityRate: 0.01), CountrySummaryMeasurementForDecodingOnly(country: "Another country", countryCode: "AC", totalConfirmed: 20, newConfirmed: 2, totalDeaths: 2, newDeaths: 0, totalRecovered: 10, newRecovered: 2, active: 15, newActive: 3, caseFatalityRate: 0.02)])
    
    static let countriesFromSummaryResponse = [Country(code: "SC", name: "Some country", latest: CountrySummaryMeasurement(totalConfirmed: 20, newConfirmed: 1, totalDeaths: 1, newDeaths: 0, totalRecovered: 10, newRecovered: 1, active: nil, newActive: nil, caseFatalityRate: 0.01)), Country(code: "AC", name: "Another country", latest: CountrySummaryMeasurement(totalConfirmed: 20, newConfirmed: 2, totalDeaths: 2, newDeaths: 0, totalRecovered: 10, newRecovered: 2, active: 15, newActive: 3, caseFatalityRate: 0.0175))]
    
    static let latestGlobalFromSummaryResponse = GlobalMeasurement(lastUpdate: Date(), totalConfirmed: 100, newConfirmed: 20, totalDeaths: 5, newDeaths: 1, totalRecovered: 30, newRecovered: 4, active: 40, newActive: 10, caseFatalityRate: 0.015)
    
    static let countryProvincesResponse = CountryProvincesResponse(data: [ProvinceMeasurementForDecodingOnly(date: date, confirmed: 5, confirmedDiff: 6, deaths: 9, deathsDiff: 10, recovered: 7, recoveredDiff: 8, active: 11, activeDiff: 12, fatalityRate: 0.005, region: ProvinceMeasurementRegionForDecodingOnly(iso: "US", name: "United States", province: "New York", lat: "40.780433", long: "-73.874752"))])
    
    static let countries = [Country(code: "US", name: "United States", latest: CountrySummaryMeasurement(totalConfirmed: 200, newConfirmed: 50, totalDeaths: 18, newDeaths: 10, totalRecovered: 100, newRecovered: 30, active: 5, newActive: 2, caseFatalityRate: 0.005), measurements: [CountryHistoryMeasurement(confirmed: 100, deaths: 2, recovered: 20, active: 10, date: Date()), CountryHistoryMeasurement(confirmed: 120, deaths: 4, recovered: 35, active: 15, date: Date() + 86_400), CountryHistoryMeasurement(confirmed: 150, deaths: 8, recovered: 70, active: 20, date: Date() + 192_800)], provinces: [Province(name: "Washington", measurements: [ProvinceMeasurement(date: Date(), totalConfirmed: 5, newConfirmed: 6, totalRecovered: 7, newRecovered: 8, totalDeaths: 9, newDeaths: 10, active: 11, newActive: 12, caseFatalityRate: 0.005)])]), Country(code: "empty", name: "Empty country", latest: CountrySummaryMeasurement(totalConfirmed: 0, newConfirmed: 0, totalDeaths: 0, newDeaths: 0, totalRecovered: 0, newRecovered: 0, active: 10, newActive: 4, caseFatalityRate: 0.005))]
    
    static let countryHistoryMeasurementsForDecodingOnly = [CountryHistoryMeasurementForDecodingOnly(cases: 100, confirmed: 100, deaths: 10, recovered: 40, active: 50, caseFatalityRate: 0.01, date: date, status: .confirmed, country: "Some country", countryCode: "SC", lat: "0.0", lon: "0.0"), CountryHistoryMeasurementForDecodingOnly(cases: 50, confirmed: nil, deaths: 5, recovered: 20, active: 25, caseFatalityRate: 0.01, date: date, status: .confirmed, country: "Another country", countryCode: "AC", lat: "", lon: "")]
    
    static let dataForPreviews = [[3, 7, 32, 1, 4, 7, 8, 45, 2, 1, 45, 6, 23], [45, 78, 105, 120, 120, 50, 584, 920, 458, 1050]].map {$0.map {Double($0)}}
    static let futureEstimationProvider = FutureEstimationProvider(provider: countries[0], estimationInterval: 7, metric: .confirmed)
}
