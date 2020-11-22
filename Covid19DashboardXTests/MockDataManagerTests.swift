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
    }
    
    func testGetHistoryData() {
        MDM.forceError = nil
        MDM.getHistoryData(for: MockData.countries[0]) { result in
            switch result {
            case .success(let (country, measurements)):
                XCTAssertEqual(country, MockData.countries[0])
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        
        MDM.forceError = NetworkError.noResponse
        MDM.getHistoryData(for: MockData.countries[0]) { result in
            switch result {
            case .success(let (country, measurements)):
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error, .noResponse)
            }
        }
    }
    
    func testGetProvinceData() {
        MDM.forceError = nil
        MDM.getProvinceData(for: MockData.countries[0]) { result in
            XCTAssertEqual(result, .success(MockData.countries[0]))
        }
        
        MDM.forceError = NetworkError.constrainedNetwork
        MDM.getProvinceData(for: MockData.countries[0], at: Date()) { result in
            XCTAssertEqual(result, .failure(.constrainedNetwork))
        }
    }
    
    func testGetDetailedCountryData() {
        MDM.forceError = nil
        MDM.getDetailedCountryData(for: MockData.countries[0], at: Date()) { result in
            XCTAssertEqual(result, .success(MockData.countries[0]))
        }
        
        MDM.forceError = NetworkError.invalidResponse(response: "Hello, world!")
        MDM.getDetailedCountryData(for: MockData.countries[0], at: Date()) { result in
            XCTAssertEqual(result, .failure(.invalidResponse(response: "Hello, world!")))
        }
    }
}
