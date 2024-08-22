//
//  ExpiredBadgesTabViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/03/24.
//

import XCTest

final class ExpiredBadgesTabViewUITests: XCTestCase {
	
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
	}
	
	private func setUpTestingEnvironment(mockFileName: String = "LoyaltyProgramMemberBadges") {
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["currect_date": "2024-03-31"]
		app.launchEnvironment = ["mock_member_badge_filename": mockFileName]
		app.launch()
	}
	
	func testUIElements() {
		setUpTestingEnvironment()
		BadgesViewHelper.goToMyBadgesView(app: app)
		app.staticTexts["Expired"].tap()
		BadgesViewHelper.pullToRefresh(app: app)
		let activeGames = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'expired'"))
		XCTAssertTrue(activeGames.firstMatch.waitForExistence(timeout: 3))
		XCTAssert(app.staticTexts["NTO Vlogger"].exists)
		XCTAssert(app.staticTexts["The one creates vlog and influence people"].exists)
	}
	
	func testExpiredBadgeDetailView() {
		setUpTestingEnvironment()
		BadgesViewHelper.goToMyBadgesView(app: app)
		app.staticTexts["Expired"].tap()
		BadgesViewHelper.pullToRefresh(app: app)
		app.staticTexts["NTO Vlogger"].tap()
		let focuesedBadge = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'NTO Vlogger'"))
		XCTAssertEqual(focuesedBadge.count, 2)
		XCTAssertTrue(app.staticTexts["Badge expired on"].exists)
		XCTAssertTrue(app.staticTexts["Learn More"].exists)
		XCTAssertTrue(app.images["ic-close"].exists)
		app.images["ic-close"].tap()
		XCTAssertFalse(app.staticTexts["Learn More"].exists)
	}
	
	func testReloadingExpiredBadgesView() {
		setUpTestingEnvironment()
		BadgesViewHelper.goToMyBadgesView(app: app)
		app.staticTexts["Expired"].tap()
		// Refreshing to clear cache and fetch data from mock file.
		BadgesViewHelper.pullToRefresh(app: app)
		XCTAssertTrue(app.staticTexts["NTO Vlogger"].waitForExistence(timeout: 3))
		app.terminate()
		setUpTestingEnvironment(mockFileName: "LoyaltyProgramMemberBadgesWithTwoObjects")
		BadgesViewHelper.goToMyBadgesView(app: app)
		app.staticTexts["Expired"].tap()
		// We cant test in first refresh because we wont know what data present in cache to compare if fresh worked.
		// So we are doing second refresh and comparing the data with first refresh.
		BadgesViewHelper.pullToRefresh(app: app)
		XCTAssertFalse(app.staticTexts["NTO Vlogger"].exists)
		XCTAssertTrue(app.staticTexts["No expired badges"].waitForExistence(timeout: 2))
	}
	
	func testErrorView() {
		setUpTestingEnvironment(mockFileName: "LoyaltyProgramMemberBadgesWithoutId")
		BadgesViewHelper.goToMyBadgesView(app: app)
		app.staticTexts["Expired"].tap()
		// Refreshing to clear cache and fetch data from mock file.
		BadgesViewHelper.pullToRefresh(app: app)
		XCTAssertTrue(app.staticTexts["We couldn’t get your badges."].exists)
	}
	
}
