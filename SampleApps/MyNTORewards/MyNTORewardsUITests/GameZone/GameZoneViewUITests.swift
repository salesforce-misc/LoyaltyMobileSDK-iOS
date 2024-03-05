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
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success"]
        app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
    }
	
	func test_onLaunch_shouldSeeTwoGames() {
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 5), "Game lazy grid should be visible")
		
		let activeGames = grid.images.containing(NSPredicate(format: "identifier CONTAINS 'active_game'"))
		XCTAssertEqual(activeGames.count, 2, "There should be 2 games on the screen")
	}
    
    func testGameZoneViewUIElements() {
        XCTAssert(app.staticTexts["Game Zone"].exists)
        XCTAssert(app.staticTexts["Available"].exists)
		XCTAssert(app.staticTexts["Played"].exists)
        XCTAssert(app.staticTexts["Expired"].exists)
    }
    
    func testTab() {
        XCTAssert(app.staticTexts["Available"].waitForExistence(timeout: 2))
        app.staticTexts["Available"].tap()
		let activeItem = app.staticTexts.containing(NSPredicate(format: "identifier CONTAINS 'active_game'"))
		
		XCTAssertNotEqual(activeItem.count, 0, "Available items count should not be 0.")
        XCTAssertFalse(app.staticTexts["Expired in the last 90 Days"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 1))
        XCTAssert(app.staticTexts["No longer available"].waitForExistence(timeout: 2))
    }
    
    func testScratchCardNavigation() {
        GameZoneViewHelper.goToScratchCardView(app: app)
        XCTAssert(app.staticTexts["Cat Scratch Fever Returns"].waitForExistence(timeout: 1))
    }
    
    func testSpinaWheelNavigation() {
        GameZoneViewHelper.goToSpinAWheelView(app: app)
        XCTAssert(app.staticTexts["Billy the Kid Promotion"].waitForExistence(timeout: 1))
    }
    
    func testExpiredTabNavigation() {
        XCTAssert(app.staticTexts["Expired"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 5))
        let gameZoneCard = app.images["img-scratch-card"].firstMatch
        gameZoneCard.tap()
        XCTAssertFalse(app.staticTexts["Scratch and win!"].waitForExistence(timeout: 2))
    }

	func testPlayedTabNavigation() {
		XCTAssert(app.staticTexts["Played"].waitForExistence(timeout: 2))
		app.staticTexts["Played"].tap()
		XCTAssert(app.staticTexts["game_zone_played_card_title"].waitForExistence(timeout: 5))
	}
}
