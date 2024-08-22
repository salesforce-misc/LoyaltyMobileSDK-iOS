//
//  MyReferralViewUnEnrolledUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 01/02/24.
//

import XCTest

final class MyReferralViewUnEnrolledUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["isEnrolled": "false"]
		app.launch()
		ReferralViewHelper.goToReferralView(app: app)
	}
	
	func test_UIElements() {
		XCTAssertTrue(app.buttons["Refer Now"].waitForExistence(timeout: 5))
		app.buttons["Refer Now"].tap()
		XCTAssertTrue(app.staticTexts["refer_friend_title"].waitForExistence(timeout: 5))
		XCTAssertTrue(app.buttons["join_refer_button"].exists)
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_onTappingBack_shouldTakeToMore() {
		app.buttons["Refer Now"].tap()
		XCTAssert(app.buttons["join_refer_button"].waitForExistence(timeout: 5))
		app.buttons["Back"].tap()
		XCTAssert(app.staticTexts["My Referrals"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["join_refer_button"].waitForExistence(timeout: 5))
	}
	
	func test_joinButton() {
		app.buttons["Refer Now"].tap()
		XCTAssert(app.buttons["join_refer_button"].waitForExistence(timeout: 5))
		app.buttons["join_refer_button"].tap()
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Try joining again.'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
}
