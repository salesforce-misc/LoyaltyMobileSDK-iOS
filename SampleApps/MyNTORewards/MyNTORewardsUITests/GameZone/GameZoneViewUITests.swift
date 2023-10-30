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
    
    func testTab() {
        GameZoneViewHelper.goToGameZoneView(app: app)
        XCTAssert(app.staticTexts["Active"].waitForExistence(timeout: 2))
        app.staticTexts["Active"].tap()
        XCTAssert(app.staticTexts["game_zone_active_card_title"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["Expired in the last 90 Days"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 1))
        XCTAssert(app.staticTexts["Expired in the last 90 Days"].waitForExistence(timeout: 2))
    }
    
    func testScratchCardNavigation() {
        GameZoneViewHelper.goToScarthCardView(app: app)
        XCTAssert(app.staticTexts["Scratch and win!"].waitForExistence(timeout: 1))
    }
    
    func testSpinaWheelNavigation() {
        GameZoneViewHelper.goToSpinaWheelView(app: app)
        XCTAssert(app.staticTexts["Spin a wheel!"].waitForExistence(timeout: 1))
    }
    
    func testExpiredTabNavigation() {
        GameZoneViewHelper.goToGameZoneView(app: app)
        XCTAssert(app.staticTexts["Expired"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 5))
        let gameZoneCard = app.images["img-fortune-wheel"].firstMatch
        gameZoneCard.tap()
        XCTAssertFalse(app.staticTexts["Spin a wheel!"].waitForExistence(timeout: 2))
    }
}
