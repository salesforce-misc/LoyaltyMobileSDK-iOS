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
	
	func test_onLaunch_shouldSeeThreeGames() {
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 5), "Game lazy grid should be visible")
		
		let items = grid.buttons
		XCTAssertEqual(items.count, 3, "There should be 3 games on the screen")
		
		let scratchCardItems = items.containing(NSPredicate(format: "identifier CONTAINS 'scratch_card_item'"))
		let spinAWheelItems = items.containing(NSPredicate(format: "identifier CONTAINS 'spin_a_wheel_item'"))
		
		XCTAssertEqual(scratchCardItems.count, 1)
		XCTAssertEqual(spinAWheelItems.count, 2)
		
		let firstItem = items.containing(NSPredicate(format: "identifier CONTAINS '#1'"))
		let secondItem = items.containing(NSPredicate(format: "identifier CONTAINS '#2'"))
		let thirdItem = items.containing(NSPredicate(format: "identifier CONTAINS '#3'"))
		
		XCTAssertTrue(firstItem.staticTexts["Bonnie and Clyde Style Promotion"].exists)
		XCTAssertTrue(firstItem.staticTexts["Spin a Wheel"].exists)
		XCTAssertTrue(firstItem.staticTexts["Expiry 23 Dec 2023"].exists)
		
		XCTAssertTrue(secondItem.staticTexts["Billy the Kid Promotion"].exists)
		XCTAssertTrue(secondItem.staticTexts["Spin a Wheel"].exists)
		XCTAssertTrue(secondItem.staticTexts["Never Expires"].exists)
		
		XCTAssertTrue(thirdItem.staticTexts["Cat Scratch Fever Returns"].exists)
		XCTAssertTrue(thirdItem.staticTexts["Scratch Card"].exists)
		XCTAssertTrue(thirdItem.staticTexts["Expiry 01 Nov 2024"].exists)
	}
    
    func testGameZoneViewUIElements() {
        XCTAssert(app.staticTexts["Game Zone"].exists)
        XCTAssert(app.staticTexts["Active"].exists)
        XCTAssert(app.staticTexts["Expired"].exists)
    }
    
    func testTab() {
        XCTAssert(app.staticTexts["Active"].waitForExistence(timeout: 2))
        app.staticTexts["Active"].tap()
		let items = app.otherElements["game_grid"].buttons
		let activeItem = items.containing(NSPredicate(format: "identifier CONTAINS 'active_game'"))
		
		XCTAssertNotEqual(activeItem.count, 0, "Active items count should not be 0.")
        XCTAssertFalse(app.staticTexts["Expired in the last 90 Days"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 1))
        XCTAssert(app.staticTexts["Expired in the last 90 Days"].waitForExistence(timeout: 2))
    }
    
    func testScratchCardNavigation() {
        GameZoneViewHelper.goToScratchCardView(app: app)
        XCTAssert(app.staticTexts["Scratch a Card and Win"].waitForExistence(timeout: 1))
    }
    
    func testSpinaWheelNavigation() {
        GameZoneViewHelper.goToSpinAWheelView(app: app)
        XCTAssert(app.staticTexts["Spin a wheel"].waitForExistence(timeout: 1))
    }
    
    func testExpiredTabNavigation() {
        XCTAssert(app.staticTexts["Expired"].waitForExistence(timeout: 2))
        app.staticTexts["Expired"].tap()
        XCTAssert(app.staticTexts["game_zone_expired_card_title"].waitForExistence(timeout: 5))
        let gameZoneCard = app.images["img-scratch-card"].firstMatch
        gameZoneCard.tap()
        XCTAssertFalse(app.staticTexts["Scratch and win!"].waitForExistence(timeout: 2))
    }
}
