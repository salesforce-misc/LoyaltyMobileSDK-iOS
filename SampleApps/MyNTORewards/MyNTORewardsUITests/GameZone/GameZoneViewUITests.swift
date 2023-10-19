//
//  GameZoneViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Damodaram Nandi on 19/10/23.
//

import XCTest

final class GameZoneViewUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
        app.launch()
    }
    
    func testGameZoneViewUIElements() {
        GameZoneViewHelper.goToGameZoneView(app: app)
        XCTAssert(app.staticTexts["Game Zone"].exists)
        XCTAssert(app.staticTexts["Active"].exists)
        XCTAssert(app.staticTexts["Expired"].exists)
    }
}
