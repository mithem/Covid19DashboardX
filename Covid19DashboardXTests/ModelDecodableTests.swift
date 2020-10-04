//
//  ModelDecodableTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 29.09.20.
//

import XCTest
@testable import Covid19DashboardX

class ModelDecodableTests: XCTestCase {
    
    let myCountry = #"{"Country":"My Country","CountryCode":"PN","NewConfirmed":1,"TotalConfirmed":2,"NewDeaths":3,"TotalDeaths":4,"NewRecovered":5,"TotalRecovered":6,"slug": "probably not","Date":"2020-04-05T06:37:00Z"}"#
    let myCountryMeasurement = CountrySummaryMeasurement(country: "My Country", countryCode: "PN", date:  Calendar.current.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2020, month: 4, day: 5, hour: 6, minute: 37))!, totalConfirmed: 2, newConfirmed: 1, totalDeaths: 4, newDeaths: 3, totalRecovered: 6, newRecovered: 5, slug: "probably not")
    let myGlobal = #"{"NewConfirmed": 100282,"TotalConfirmed": 1162857,"NewDeaths": 5658,"TotalDeaths": 63263,"NewRecovered": 15405,"TotalRecovered": 230845}"#
    let myGlobalMeasurement = GlobalMeasurement(totalConfirmed: 1162857, newConfirmed: 100282, totalDeaths: 63263, newDeaths: 5658, totalRecovered: 230845, newRecovered: 15405)
    
    func testGlobalMeasurement() {
        let input = myGlobal.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        let result = try? decoder.decode(GlobalMeasurement.self, from: input)
        let expected = GlobalMeasurement(totalConfirmed: 1162857, newConfirmed: 100282, totalDeaths: 63263, newDeaths: 5658, totalRecovered: 230845, newRecovered: 15405)
        XCTAssertEqual(result, expected)
    }
    
    func testCountryMeasurement() {
        let input = myCountry.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .iso8601
        var result: CountrySummaryMeasurement?
        do {
            result = try decoder.decode(CountrySummaryMeasurement.self, from: input)
        } catch {
            print(error)
        }
        
        XCTAssertEqual(result, myCountryMeasurement)
    }
    
    func testFullRespone() {
        let input = (#"{"Global": "# + myGlobal + #", "Countries": ["# + myCountry + #"], "Date": "2020-08-23T12:12:37Z"}"#).data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .iso8601
        var result: SummaryResponse?
        do {
            result = try decoder.decode(SummaryResponse.self, from: input)
        } catch {
            print(error)
        }
        let expected = SummaryResponse(global: myGlobalMeasurement, countries: [myCountryMeasurement], date: Calendar.current.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2020, month: 8, day: 23, hour: 12, minute: 12, second: 37))!)
        
        XCTAssertEqual(result, expected)
    }
}
