//
//  ScratchCardViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 15/12/23.
//

import XCTest

final class ScratchCardViewSuccessUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_scratch_card": "success"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	func test_scratchCardUIElements() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		let title = app.staticTexts["Scratch and win!"]
		XCTAssertTrue(title.waitForExistence(timeout: 1))
		
		let subtitle = app.staticTexts["Get a chance to win instant rewards!"]
		XCTAssertTrue(subtitle.exists)
		
		let footerTitle = app.staticTexts["Scratch coupon to play"]
		XCTAssertTrue(footerTitle.exists)
		
		let footerBody = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'This is a one time offer exclusively for you.'")).firstMatch
		XCTAssertTrue(footerBody.exists)
		
		let wrapperTexts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'SCRATCH TO WIN! SCRATCH TO WIN! SCRATCH TO WIN!'")).firstMatch
		XCTAssertTrue(wrapperTexts.exists)
		
		wrapperTexts.swipeRight(velocity: .slow)
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		
		XCTAssertFalse(loadingView.waitForExistence(timeout: 2))
		XCTAssertTrue(app.staticTexts["50% Off"].exists)
		
		XCTAssertTrue(app.staticTexts["Congratulations!!!"].waitForExistence(timeout: 5))
		XCTAssertTrue(app.staticTexts["You have won \n A voucher of 50% Off for your next purchase. \nGo to the voucher section to claim your reward!"].exists)
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
}
