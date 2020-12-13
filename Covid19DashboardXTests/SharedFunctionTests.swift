//
//  SharedFunctionTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 13.12.20.
//

import XCTest

class SharedFunctionTests: XCTestCase {
    /// Test natural log function
    func testLn() {
        var range = (-2.3025851 ... -2.302585)
        XCTAssertTrue(range ~= ln(0.1))
        
        range = (-0.6931472 ... -0.6931471)
        XCTAssertTrue(range ~= ln(0.5))

        range = (0.4054651 ... 0.40546511)
        XCTAssertTrue(range ~= ln(1.5))
        
        range = (0.6931471 ... 0.6931472)
        XCTAssertTrue(range ~= ln(2))
        
        range = (4.605170 ... 4.606171)
        XCTAssertTrue(range ~= ln(100))
        
        let precision = Double(pow(10.0, -15))
        for power in (0...100).map({Double($0)}) {
            XCTAssertTrue(((power - precision) ... (power + precision)) ~= ln(pow(Double.eulersNumber, power)))
        }
    }
    
    func testCalculateDoublingRate() {
        var range = (1.709511291 ... 1.709511292)
        var result = calculateDoublingRate(new: 5, total: 10, in: 1)
        XCTAssertTrue(range ~= result, result.description)
        
        range = (2.40942083 ... 2.40942084)
        result = calculateDoublingRate(new: 5, total: 15, in: 1)
        XCTAssertTrue(range ~= result, result.description)
        
        range = (7.272540897 ... 7.272540898)
        result = calculateDoublingRate(new: 1, total: 10, in: 1)
        XCTAssertTrue(range ~= result, result.description)
        
        range = (3.80178401692 ... 3.80178401693)
        result = calculateDoublingRate(new: 6, total: 10, in: 3)
        XCTAssertTrue(range ~= result, result.description)
        
        range = (7.272540897 ... 7.272540898)
        result = calculateDoublingRate(new: 100, total: 100, in: 10)
        XCTAssertTrue(range ~= result, result.description)
    }
}
