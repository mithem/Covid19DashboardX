//
//  MockDataManagerTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import XCTest

class MockDataManagerTests: XCTestCase {
    
    typealias MDM = MockDataManager
    
    func testGetSummary() {
        MDM.forceError = nil
        MDM.getSummary { result in
            XCTAssertEqual(result, .success(MockData.summaryResponse))
        }
        
        MDM.forceError = NetworkError.noNetworkConnection
        MDM.getSummary { result in
            XCTAssertEqual(result, .failure(.noNetworkConnection))
        }
        
        MDM.forceError = NetworkError.cachingInProgress
        MDM.getSummary { result in
            XCTAssertEqual(result, .failure(.cachingInProgress))
        }
    }
    
    func testGetHistoryData() {
        MDM.forceError = nil
        MDM.getHistoryData(for: MockData.countries[0]) { result in
            switch result {
            case .success(let (country, _)):
                XCTAssertEqual(country, MockData.countries[0])
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        MDM.forceError = NetworkError.noResponse
        MDM.getHistoryData(for: MockData.countries[0]) { result in
            switch result {
            case .success(_):
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error, .noResponse)
            }
        }
    }
    
    func testGetProvinceData() {
        MDM.forceError = nil
        MDM.getProvinceData(for: MockData.countries[0]) { result in
            XCTAssertEqual(result, .success(MockData.countryProvincesResponse))
        }
        
        MDM.forceError = NetworkError.constrainedNetwork
        MDM.getProvinceData(for: MockData.countries[0], at: Date()) { result in
            XCTAssertEqual(result, .failure(.constrainedNetwork))
        }
    }
    
    func testGetGlobalSummary() {
        MDM.forceError = nil
        MDM.getGlobalSummary { result in
            switch result {
            case .success(let measurement):
                XCTAssertEqual(measurement, MockData.latestGlobalFromSummaryResponse)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        let responseText = "Hello, world!"
        
        MDM.forceError = NetworkError.invalidResponse(response: responseText)
        MDM.getGlobalSummary { result in
            switch result {
            case .success(_):
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse(response: responseText))
            }
        }
    }
}
