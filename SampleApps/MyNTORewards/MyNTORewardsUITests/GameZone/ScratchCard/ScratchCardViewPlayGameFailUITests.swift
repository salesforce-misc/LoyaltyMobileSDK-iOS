//
//  ScratchCardViewPlayGameFailUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 15/12/23.
//

import XCTest

final class ScratchCardViewPlayGameFailUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success",
								 "play_scratch_card": "fail"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
	}
	
	private final func scratchTheCard() {
		let wrapperTexts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'SCRATCH & WIN  SCRATCH & WIN  SCRATCH & WIN'")).firstMatch
		wrapperTexts.swipeRight(velocity: .slow)
	}
	
	func test_playGame_shouldShowErrorScreen_whenApiFails() {
		GameZoneViewHelper.goToScratchCardView(app: app)
		scratchTheCard()
		
		let loadingView = app.staticTexts["Loading..."]
		XCTAssertTrue(loadingView.exists)
		
		XCTAssertTrue(app.staticTexts["Oops! Something went wrong while processing the request. Try again."].waitForExistence(timeout: 2))
		XCTAssertTrue(app.buttons["Try Again"].exists)
		XCTAssertTrue(app.images["img-astronaut"].exists)
	}
}
