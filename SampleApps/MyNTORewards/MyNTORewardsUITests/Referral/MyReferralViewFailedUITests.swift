//
//  MyReferralViewFailedUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 28/02/24.
//

import XCTest

final class MyReferralViewFailedUITests: XCTestCase {
	
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
	}
	
	func test_UIElements() {
		app.launchEnvironment = ["loadingState": "failed"]
		app.launch()
		ReferralViewHelper.goToReferralView(app: app)
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Something went wrong'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_ReferAFriendView() {
		app.launchEnvironment = ["mockEnrollmentStatusApiState": "failed", "mockPromotionStatusApiState": "failed"]
		app.launch()
		ReferralViewHelper.goToReferralView(app: app)
		XCTAssertTrue(app.buttons["Refer Now"].waitForExistence(timeout: 5))
		app.buttons["Refer Now"].tap()
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Something went wrong'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_ReferralPromotionFailedViewTests() {
		app.launchEnvironment = ["mockEnrollmentStatusApiState": "failed", 
								 "mockPromotionStatusApiState": "failed",
								 "mockPromotionScreenType": "joinPromotionError"
		]
		app.launch()
		XCTAssertTrue(app.staticTexts["Refer and Save"].exists)
		app.staticTexts["Refer and Save"].tap()
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Something went wrong'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_ReferralPromotionJoinPromotionErrorTests() {
		app.launchEnvironment = ["mockPromotionStatusApiState": "loaded",
								 "mockPromotionScreenType": "joinPromotionError"
		]
		app.launch()
		XCTAssertTrue(app.staticTexts["Refer and Save"].exists)
		app.staticTexts["Refer and Save"].tap()
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Something went wrong'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
		XCTAssertTrue(app.buttons["Back"].exists)
		app.buttons["Back"].tap()
		XCTAssertFalse(errorView.firstMatch.exists)
	}
}
