//
//  APIConfigTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 21.12.20.
//

import XCTest

class APIConfigTests: XCTestCase {
    
    func testSummaryResponseSuccess() {
        APIConfig.Provider1.summary.parseResponse(data: MockData.summaryResponse.encode(), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, MockData.summaryResponse)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testSummaryResponseSSLError() {
        APIConfig.Provider1.summary.parseResponse(data: nil, response: nil, error: URLError(.serverCertificateUntrusted)) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error, .urlError(.init(.serverCertificateUntrusted)))
            }
        }
    }
    
    func testSummaryResponseServerCaching() {
        let input = #"{"message": "Caching in progress"}"#.data(using: .utf8)!
        APIConfig.Provider1.summary.parseResponse(data: input, response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .fallbackSuccessful(let data):
                XCTAssertEqual(data, ServerCachingInProgressResponse())
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
