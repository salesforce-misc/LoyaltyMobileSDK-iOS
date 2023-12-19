//
//  GameZoneExpiryLabelTests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 17/12/23.
//

import XCTest

final class GameZoneExpiryLabelTests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
	}
	
	private final func lauchApp() {
		app.launchEnvironment = ["get_games": "success"]
		app.launch()
	}
	
	private final func launchWithExpiringToday() {
		app.launchEnvironment = ["get_games": "success", "expiry": "today"]
		app.launch()
	}
	
	private final func launchWithExpiringTomorrow() {
		app.launchEnvironment = ["get_games": "success", "expiry": "tomorrow"]
		app.launch()
	}
	
	func test_expiringTodayLabel() {
		launchWithExpiringToday()
		GameZoneViewHelper.goToGameZoneView(app: app)
		
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 3), "Game lazy grid should be visible")
		
		let items = grid.buttons
		XCTAssertEqual(items.count, 3, "There should be 3 games on the screen")
		
		let cardsExpiringToday = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Expiring today'"))
		let cardsNeverExpire = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Never Expires'"))
		// Testing 2 items are expiring today and 1 Never Expiring.
		XCTAssertEqual(cardsExpiringToday.count, 2, "2 games should show 'Expiring today'")
		XCTAssertEqual(cardsNeverExpire.count, 1, "1 game should show 'Never Expires'")
	}
	
	func test_expiringTomorrowLabel() {
		launchWithExpiringTomorrow()
		GameZoneViewHelper.goToGameZoneView(app: app)
		
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 3), "Game lazy grid should be visible")
		
		let items = grid.buttons
		XCTAssertEqual(items.count, 3, "There should be 3 games on the screen")
		
		let cardsExpiringTomorrow = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Expiring tomorrow'"))
		let cardsNeverExpire = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Never Expires'"))
		// Testing 2 items are expiring tomorrow and 1 Never Expiring.
		XCTAssertEqual(cardsExpiringTomorrow.count, 2, "2 games should show 'Expiring tomorrow'")
		XCTAssertEqual(cardsNeverExpire.count, 1, "1 game should show 'Never Expires'")
	}
	
	func test_expiryOnDateLabel() {
		lauchApp()
		GameZoneViewHelper.goToGameZoneView(app: app)
		
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 3), "Game lazy grid should be visible")
		
		let items = grid.buttons
		XCTAssertEqual(items.count, 3, "There should be 3 games on the screen")
		
		XCTAssertTrue(app.staticTexts["Expiry 23 Dec 2023"].exists)
		XCTAssertTrue(app.staticTexts["Expiry 01 Nov 2024"].exists)
		XCTAssertTrue(app.staticTexts["Expiry 01 Nov 2024"].exists)
	}
}
