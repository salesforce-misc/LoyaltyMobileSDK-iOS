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
		XCTAssert(app.staticTexts["Join Referral Program"].waitForExistence(timeout: 5))
		
		let joinReferralProgramDescription = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Join our referral program'"))
		XCTAssertEqual(joinReferralProgramDescription.count, 1)
		
		XCTAssertTrue(app.buttons["Join"].exists)
		XCTAssertTrue(app.buttons["Back"].exists)
	}
	
	func test_onTappingBack_shouldTakeToMore() {
		XCTAssert(app.staticTexts["Join Referral Program"].waitForExistence(timeout: 5))
		app.buttons["Back"].tap()
		XCTAssertTrue(app.staticTexts["Log Out"].waitForExistence(timeout: 5))
	}
	
	func test_joinButton() {
		XCTAssert(app.staticTexts["Join Referral Program"].waitForExistence(timeout: 5))
		app.buttons["Join"].tap()
		let errorView = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Try joining again.'"))
		XCTAssertTrue(errorView.firstMatch.waitForExistence(timeout: 5))
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
}
