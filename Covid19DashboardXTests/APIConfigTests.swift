//
//  APIConfigTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 21.12.20.
//

import XCTest

class APIConfigTests: XCTestCase {
    
    let invalidJSONerrorMessage = "The data couldn’t be read because it isn’t in the correct format."
    
    struct CustomDataType: CustomCodable, Equatable {
        typealias Encoder = CustomJSONEncoder
        typealias Decoder = CustomJSONDecoder
        let message: String
        let code: Int
    }
    
    struct AnotherCustomDataType: CustomCodable, Equatable {
        typealias Encoder = CustomJSONEncoder
        typealias Decoder = CustomJSONDecoder
        let number: Int
        let confirmation: Bool
    }
    
    struct EndpointWithoutFallback: APIEndpoint {
        typealias DataType = CustomDataType
        typealias FallbackDataType = CustomDataType
        static var ignoreLowDataMode = true
        static var url = "https://localhost"
    }
    
    struct EndpointWithFallback: APIEndpoint {
        typealias DataType = CustomDataType
        typealias FallbackDataType = AnotherCustomDataType
        static var ignoreLowDataMode = false
        static var url = "https://localhost"
    }
    
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
    
    func testAPIEndpointDecodingWithoutFallbackSuccess() {
        let input = CustomDataType(message: "Hello, world!", code: 1)
        EndpointWithoutFallback.parseResponse(data: input.encode(), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, input)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testAPIEndpointDecodingWithoutFallbackFailure1() {
        let input = "Hello, world!; 1"
        EndpointWithoutFallback.parseResponse(data: input.data(using: .utf8), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse(response: self.invalidJSONerrorMessage))
            }
        }
    }
    
    func testAPIEndpointDecodingWithoutFallbackFailure2() {
        EndpointWithoutFallback.parseResponse(data: nil, response: nil, error: URLError(.serverCertificateUntrusted)) { result in
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
    
    func testAPIEndpointDecodingWithFallbackSuccess1() {
        let input = CustomDataType(message: "Hello, there!", code: 2)
        EndpointWithFallback.parseResponse(data: input.encode(), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, input)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testAPIEndpointDecodingWithFallbackSuccess2() {
        let input = AnotherCustomDataType(number: 10, confirmation: true)
        EndpointWithFallback.parseResponse(data: input.encode(), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .fallbackSuccessful(let data):
                XCTAssertEqual(data, input)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testAPIEndpointDecodingWithFallbackFailure() {
        let input = "hello, there"
        EndpointWithFallback.parseResponse(data: input.data(using: .utf8), response: nil, error: nil) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(data)
            case .fallbackSuccessful(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, self.invalidJSONerrorMessage)
            }
        }
    }
    
}
