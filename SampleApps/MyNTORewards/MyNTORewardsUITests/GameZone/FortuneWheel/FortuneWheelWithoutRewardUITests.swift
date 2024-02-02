//
//  FortuneWheelWithoutRewardUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 16/12/23.
//

import XCTest

final class FortuneWheelWithoutRewardUITests: XCTestCase {
	
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_spin_a_wheel": "no_reward"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	private final func spinTheWheel() {
		app.buttons["SPIN"].tap()
	}
	
	func test_playGame_shouldShowBetterLuckNextTimeScreen_whenNotRewarded() {
		GameZoneViewHelper.goToSpinAWheelView(app: app)
		spinTheWheel()
		
		XCTAssertTrue(app.staticTexts["Thank you for playing! Stay tuned for more offers."].waitForExistence(timeout: 10))
	}
	
}
