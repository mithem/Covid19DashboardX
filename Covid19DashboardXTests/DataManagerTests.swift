//
//  DataManagerTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import XCTest

class DataManagerTests: XCTestCase {
    typealias MDM = MockDataManager
    
    func testParseSummarySuccess() {
        MDM.forceError = nil
        MDM.getSummary { result in
            switch MDM.parseSummary(result) {
            case .success(let countries):
                XCTAssertEqual(countries, MockData.countriesFromSummaryResponse)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testParseSummaryError() {
        MDM.forceError = NetworkError.cachingInProgress
        MDM.getSummary { result in
            switch MDM.parseSummary(result) {
            case .success(let countries):
                XCTAssertNil(countries)
            case .failure(let error):
                XCTAssertEqual(error, .cachingInProgress)
            }
        }
    }
    
    func testParseHistoryDataSuccess() {
        MDM.forceError = nil
        MDM.getHistoryData(for: MockData.countries[0]) { result in
            switch MDM.parseHistoryData(result) {
            case .success(let country):
                XCTAssertEqual(country, MockData.countries[0])
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
