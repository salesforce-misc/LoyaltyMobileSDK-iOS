//
//  AvailableBadgesTabViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/03/24.
//

import XCTest

final class AvailableBadgesTabViewUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["currect_date": "2024-03-31"]
		app.launch()
		BadgesViewHelper.goToMyBadgesView(app: app)
	}
	
	func testUIElements() {
		app.staticTexts["Available"].tap()
		BadgesViewHelper.pullToRefresh(app: app)
		XCTAssert(app.staticTexts["NTO Social Influencer"].exists)
		XCTAssert(app.staticTexts["Members who regularly post about NTO on social media"].exists)
		XCTAssertFalse(app.staticTexts["expires"].exists)
		XCTAssertFalse(app.staticTexts["expired"].exists)
	}
	
	func testAvailableBadgeDetailView() {
		app.staticTexts["Available"].tap()
		BadgesViewHelper.pullToRefresh(app: app)
		app.staticTexts["NTO Social Influencer"].tap()
		let focuesedBadge = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'NTO Social Influencer'"))
		XCTAssertEqual(focuesedBadge.count, 2)
		XCTAssertTrue(app.staticTexts["Not achieved yet."].exists)
		XCTAssertTrue(app.staticTexts["Learn More"].exists)
		XCTAssertTrue(app.buttons["Close"].exists)
	}
}
