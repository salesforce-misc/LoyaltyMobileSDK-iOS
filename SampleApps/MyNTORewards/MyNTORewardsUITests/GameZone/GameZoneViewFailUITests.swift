//
//  GameZoneViewFailUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 16/12/23.
//

import XCTest

final class GameZoneViewFailUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "fail"]
		app.launch()
	}
	
	func test_onLaunch_shouldErrorScreen() {
		GameZoneViewHelper.goToGameZoneView(app: app)
		XCTAssertTrue(app.staticTexts["Oops! Something went wrong while processing the request. Try again."].waitForExistence(timeout: 3))
		XCTAssertTrue(app.images["img-astronaut"].exists)
	}
}
