//
//  FortuneWheelWithRewardUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 15/12/23.
//

import XCTest

final class FortuneWheelWithRewardUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		
	}
	
	private final func spinTheWheel() {
		app.buttons["SPIN"].tap()
	}
	
	func test_fortuneWheelUIElements() {
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
		GameZoneViewHelper.goToSpinAWheelView(app: app)
		let title = app.staticTexts["Spin a wheel"]
		XCTAssertTrue(title.exists)
		
		let subtitle = app.staticTexts["Spin the wheel and unlock instant rewards!"]
		XCTAssertTrue(subtitle.exists)

		XCTAssertTrue(app.staticTexts["Get 10% Off Voucher"].exists)
		XCTAssertTrue(app.staticTexts["Get 50% Off Voucher"].exists)
		let betterLuckNextTimeLabels = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Better Luck Next Time'"))
		XCTAssertEqual(betterLuckNextTimeLabels.count, 1)
		let footerBodyString = "Grab this exclusive onetime offer and win some exciting rewards. For more information, refer to the terms and conditions."
		XCTAssertTrue(app.staticTexts[footerBodyString].exists)
		
		let spinButton = app.buttons["SPIN"]
		XCTAssertTrue(spinButton.exists)
	}
	
	func test_playGame_shouldShowCongratsScreenWithRewardValue_whenRewarded() {
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_spin_a_wheel": "rewarded"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
		GameZoneViewHelper.goToSpinAWheelView(app: app)
		spinTheWheel()
		
		XCTAssertTrue(app.staticTexts["Congratulations!"].waitForExistence(timeout: 10))
		XCTAssertTrue(app.staticTexts["You've won 50% Off that you can redeem on your next purchase."].exists)
		XCTAssertTrue(app.buttons["Play More"].exists)
	}
}
