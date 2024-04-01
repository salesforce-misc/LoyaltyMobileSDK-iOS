//
//  BadgeCardViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/03/24.
//

import XCTest

final class AllBadgesViewUITests: XCTestCase {
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
		BadgesViewHelper.pullToRefresh(app: app)
		XCTAssert(app.staticTexts["My Badges"].exists)
		XCTAssert(app.staticTexts["Achieved"].exists)
		XCTAssert(app.staticTexts["Available"].exists)
		XCTAssert(app.staticTexts["Expired"].exists)
		XCTAssert(app.staticTexts["NTO Sustainable Shopper"].exists)
		XCTAssert(app.staticTexts["Awarded to Loyalty Program Member for shopping sustainable products"].exists)
		XCTAssert(app.staticTexts["Badge expires in"].exists)
		XCTAssert(app.staticTexts["NTO Fashionista"].exists)
		XCTAssert(app.staticTexts["764 days"].exists)
		XCTAssert(app.staticTexts["Badge expires"].exists)
		XCTAssert(app.staticTexts["today"].exists)
	}
	
	func testAcheivedBadgeDetailView() {
		BadgesViewHelper.pullToRefresh(app: app)
		app.staticTexts["NTO Sustainable Shopper"].tap()
		let focuesedBadge = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'NTO Sustainable Shopper'"))
		XCTAssertEqual(focuesedBadge.count, 2)
		XCTAssertTrue(app.staticTexts["Badge expires on"].exists)
		XCTAssertTrue(app.staticTexts["Learn More"].exists)
		XCTAssertTrue(app.buttons["Close"].exists)
	}

}
