//
//  ScratchCardViewNoRewardUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 15/12/23.
//

import XCTest

final class ScratchCardViewNoRewardUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_scratch_card": "no_reward"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	private final func scratchTheCard() {
		let wrapperTexts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'SCRATCH & WIN  SCRATCH & WIN  SCRATCH & WIN'")).firstMatch
		wrapperTexts.swipeRight(velocity: .slow)
	}
	
	func test_playGame_shouldShowBetterLuckNextTime_whenNoReward() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 2))
		
		// Text displayed on the card once response is received.
		XCTAssertTrue(app.staticTexts["Better Luck Next Time!"].exists)
		
		// Should show better luck next time screen after 3 seconds.
		XCTAssertTrue(app.staticTexts["Thank you for playing! Stay tuned for more offers."].waitForExistence(timeout: 3))
		XCTAssertTrue(app.staticTexts["Better luck next time!"].exists)
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_playGame_shouldNotTakeMoreThan3SecondsToShowNotRewardedScreen() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 1))
		
		// Should not take more than 3 seconds to show not rewarded screen.
		let timeDelayToShowNotRewardedScreenInSec: TimeInterval = 3
		XCTAssertTrue(app.staticTexts["Thank you for playing! Stay tuned for more offers."].waitForExistence(timeout: timeDelayToShowNotRewardedScreenInSec),
					  "It takes longer than 3 seconds to show Better Luck Next Time screen.")
		///Testing this body text instead of title text "Better Luck Next Time!" since the same text is shown in game screen when API response is received.
		///So, testing "Better Luck Next Time!" will result in success right away. We need to test "Not Rewarded" screen content after a certain delay.
	}
	
	func test_playGame_shouldNotShowNotRewardedScreenBefore3Seconds() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 1))
		
		// Should not show not rewarded screen before 3 seconds.
		let timeDelayToShowNotRewardedScreenInSec: TimeInterval = 2
		XCTAssertFalse(app.staticTexts["Thank you for playing! Stay tuned for more offers."].waitForExistence(timeout: timeDelayToShowNotRewardedScreenInSec),
					   "Better Luck Next Time screen is shown before 3 seconds.")
		///Testing this body text instead of title text "Better Luck Next Time!" since the same text is shown in game screen when API response is received.
		///So, testing "Better Luck Next Time!" will result in success right away. We need to test "Not Rewarded" screen content after a certain delay.
	}
	
	func test_tappingBack_shouldTakeToGameZone() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		XCTAssertTrue(app.staticTexts["Thank you for playing! Stay tuned for more offers."].waitForExistence(timeout: 5))
		app.buttons["Back"].tap()
		XCTAssert(app.staticTexts["Game Zone"].exists)
		XCTAssert(app.staticTexts["Active"].exists)
		XCTAssert(app.staticTexts["Expired"].exists)
	}
	
}
