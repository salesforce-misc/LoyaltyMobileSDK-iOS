//
//  MyReferralViewEnrolledUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/01/24.
//

import XCTest

final class MyReferralViewEnrolledUITests: XCTestCase {
	let app = XCUIApplication()
	
    override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["isEnrolled": "true", "mockDate": "2024-02-02", "dateFormat": "yyyy-MM-dd"]
		app.launch()
		ReferralViewHelper.goToReferralView(app: app)
    }
	
	func test_UIElements() {
		XCTAssert(app.staticTexts["My Referrals"].waitForExistence(timeout: 5))
		XCTAssert(app.staticTexts["YOUR REFERRALS in Last 90 Days"].waitForExistence(timeout: 5))
		XCTAssert(app.staticTexts["Invitations Sent"].exists)
		XCTAssert(app.staticTexts["Invitations Accepted"].exists)
		XCTAssert(app.staticTexts["Vouchers Earned"].exists)
		XCTAssert(app.staticTexts["Completed"].exists)
		XCTAssert(app.staticTexts["In Progress"].exists)
		XCTAssert(app.buttons["Refer Now"].exists)
	}

	func test_onTappingReferAFriend_shouldShowReferAFriendView() {
		XCTAssertTrue(app.buttons["Refer Now"].waitForExistence(timeout: 5))
		app.buttons["Refer Now"].tap()
		XCTAssertTrue(app.staticTexts["refer_friend_title"].waitForExistence(timeout: 5))
	}
	
	func test_completedReferralsView() {
		XCTAssert(app.staticTexts["Completed"].waitForExistence(timeout: 5))
		XCTAssert(app.staticTexts["Recent"].exists)
		XCTAssert(app.staticTexts["pulkit.shah+BUFrn141201112@salesforce.com"].exists)
		XCTAssert(app.staticTexts["Purchase Completed"].exists)
		XCTAssert(app.staticTexts["One Month Ago"].exists)
		XCTAssert(app.staticTexts["15 December 2023"].exists)
		XCTAssert(app.staticTexts["Three Months Ago"].exists)
		XCTAssert(app.staticTexts["08 June 2023"].exists)
	}
	
	func test_InProgressReferralsView() {
		XCTAssert(app.staticTexts["In Progress"].waitForExistence(timeout: 5))
		app.staticTexts["In Progress"].tap()
		XCTAssert(app.staticTexts["Recent"].exists)
		XCTAssert(app.staticTexts["siva@test.com"].exists)
		XCTAssert(app.staticTexts["Invitation Sent"].exists)
		app.swipeUp(velocity: .fast)
		app.swipeUp(velocity: .fast)
		app.swipeUp(velocity: .fast)
		app.swipeUp(velocity: .fast)
		XCTAssert(app.staticTexts["One Month Ago"].exists)
		XCTAssert(app.staticTexts["15 December 2023"].exists)
		XCTAssert(app.staticTexts["Three Months Ago"].exists)
		XCTAssert(app.staticTexts["08 June 2023"].exists)
	}
	
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
