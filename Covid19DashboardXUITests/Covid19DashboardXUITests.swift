//
//  Covid19DashboardXUITests.swift
//  Covid19DashboardXUITests
//
//  Created by Miguel Themann on 28.11.20.
//

import XCTest

class Covid19DashboardXUITests: XCTestCase {
    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testSettingsRoundTrip() {
        
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Covid19 Summary"].buttons["gear"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["General"]/*[[".cells[\"General\"].buttons[\"General\"]",".buttons[\"General\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["General"].buttons["Settings"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Notifications"]/*[[".cells[\"Notifications\"].buttons[\"Notifications\"]",".buttons[\"Notifications\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Notifications"].buttons["Settings"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Spotlight"]/*[[".cells[\"Spotlight\"].buttons[\"Spotlight\"]",".buttons[\"Spotlight\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Spotlight"].buttons["Settings"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Other"]/*[[".cells[\"Other\"].buttons[\"Other\"]",".buttons[\"Other\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Other"].buttons["Settings"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Attributions"]/*[[".cells[\"Attributions\"].buttons[\"Attributions\"]",".buttons[\"Attributions\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Attributions"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Covid19 Summary"].tap()
        XCTAssertNotNil(app.navigationBars["Covid19 Summary"])
    }
}
