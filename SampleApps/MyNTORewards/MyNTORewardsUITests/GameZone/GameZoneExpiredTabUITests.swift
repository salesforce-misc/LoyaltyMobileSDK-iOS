//
//  GameZoneExpiredTabUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 17/12/23.
//

import XCTest

final class GameZoneExpiredTabUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	func test_expiredTabUIElements() {
		app.staticTexts["Expired"].tap()
		
		XCTAssertTrue(app.staticTexts["Expired in the last 90 Days"].exists)
		let scratchCardItems = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Scratch Card'"))
		XCTAssertEqual(scratchCardItems.count, 1)
		let spinAWheelItems = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Spin a Wheel'"))
		XCTAssertEqual(spinAWheelItems.count, 1)
	}
	
}
