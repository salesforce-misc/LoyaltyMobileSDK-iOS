//
//  ScratchCardViewRewardedUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 15/12/23.
//

import XCTest

final class ScratchCardViewRewardedUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_scratch_card": "rewarded"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	private final func scratchTheCard() {
		let wrapperTexts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'SCRATCH & WIN  SCRATCH & WIN  SCRATCH & WIN'")).firstMatch
		wrapperTexts.swipeRight(velocity: .slow)
	}
	
	func test_scratchCardUIElements() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		
		let title = app.staticTexts["Scratch a Card and Win"]
		XCTAssertTrue(title.waitForExistence(timeout: 1))
		
		let subtitle = app.staticTexts["Unlock instant rewards!"]
		XCTAssertTrue(subtitle.exists)
		
		let wrapperTexts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'SCRATCH & WIN  SCRATCH & WIN  SCRATCH & WIN'")).firstMatch
		XCTAssertTrue(wrapperTexts.exists)
		
		XCTAssertTrue(app.staticTexts["Grab this exclusive onetime offer and win some exciting rewards."].exists)
	}
	
	func test_playGame_shouldShowRewardAndCongrats_whenRewarded() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 1))
		
		XCTAssertTrue(app.staticTexts["50% Off"].exists)
		
		XCTAssertTrue(app.staticTexts["Congratulations!"].waitForExistence(timeout: 10))
		XCTAssertTrue(app.staticTexts["You've won a 50% off discount voucher for your next purchase. To redeem your reward, go to the Voucher section."].exists)
		XCTAssertTrue(app.buttons["Play More"].exists)
	}
	
	func test_playGame_shouldNotTakeMoreThan3SecondsToShowRewardedScreen() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 1))
		
		// Should not take more than 3 seconds to show rewarded screen.
		let timeDelayToShowRewardedScreenInSec: TimeInterval = 3
		XCTAssertTrue(app.staticTexts["Congratulations!"].waitForExistence(timeout: timeDelayToShowRewardedScreenInSec),
					  "It takes longer than 3 seconds to show Congrats screen.")
	}

	func test_playGame_shouldNotShowRewardedScreenBefore3Seconds() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		XCTAssertFalse(loadingView.waitForExistence(timeout: 1))
		
		// Should not show rewarded screen before 3 seconds.
		let timeDelayToShowRewardedScreenInSec: TimeInterval = 2
		XCTAssertFalse(app.staticTexts["Congratulations!"].waitForExistence(timeout: timeDelayToShowRewardedScreenInSec),
					   "Congrats screen is shown before 3 seconds.")
	}
	
	func test_tappingBack_shouldTakeToGameZone() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		XCTAssertTrue(app.staticTexts["Congratulations!"].waitForExistence(timeout: 5))
		app.buttons["Play More"].tap()
		XCTAssert(app.staticTexts["Game Zone"].exists)
		XCTAssert(app.staticTexts["Active"].exists)
		XCTAssert(app.staticTexts["Expired"].exists)
	}
}
