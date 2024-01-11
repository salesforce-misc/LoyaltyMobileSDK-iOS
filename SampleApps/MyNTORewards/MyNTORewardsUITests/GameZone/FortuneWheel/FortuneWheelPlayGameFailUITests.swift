//
//  FortuneWheelPlayGameFailUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 16/12/23.
//

import XCTest

final class FortuneWheelPlayGameFailUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_spin_a_wheel": "fail"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	private final func spinTheWheel() {
		app.buttons["SPIN"].tap()
	}
	
	func test_playGame_shouldShowErrorScreen_whenApiFails() {
		GameZoneViewHelper.goToSpinAWheelView(app: app)
		spinTheWheel()
		
		XCTAssertTrue(app.staticTexts["Oops! Something went wrong while processing the request. Try again."].waitForExistence(timeout: 3))
		XCTAssertTrue(app.buttons["Try Again"].exists)
		XCTAssertTrue(app.images["img-astronaut"].exists)
	}
}
