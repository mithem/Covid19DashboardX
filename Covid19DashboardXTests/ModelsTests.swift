//
//  ModelsTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 02.10.20.
//

import XCTest
@testable import Covid19DashboardX

class ModelsTests: XCTestCase {
    func testCountryMeasurementIterator() {
        let date = Date()
        let measurement = CountryMeasurement(country: "AAA", countryCode: "AA", date: date, totalConfirmed: 1000, newConfirmed: 2000, totalDeaths: 3000, newDeaths: 4000, totalRecovered: 5000, newRecovered: 6000)
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .decimal
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        var strings = [String]()
        
        func s(_ n: Int) -> String {
            numberFormatter.string(from: NSNumber(value: n)) ?? "unkown"
        }
        
        for string in measurement.getStats([.countryCode, .totalConfirmed, .newConfirmed, .totalDeaths, .newDeaths, .totalRecovered, .newRecovered, .date]) {
            strings.append(string)
        }
        
        XCTAssertEqual(strings, ["AA", s(1000), s(2000), s(3000), s(4000), s(5000), s(6000), dateFormatter.string(from: date)])
    }
}
