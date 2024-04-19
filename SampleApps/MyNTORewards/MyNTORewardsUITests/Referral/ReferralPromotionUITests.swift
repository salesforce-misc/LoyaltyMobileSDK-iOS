//
//  ReferralPromotionUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 28/02/24.
//

import XCTest

final class ReferralPromotionUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["referral_promotion": "true"]
		app.launch()
	}
	
	func test_UIElements() {
		XCTAssertTrue(app.staticTexts["Refer and Save"].exists)
		app.staticTexts["Refer and Save"].tap()
		XCTAssertTrue(app.staticTexts["refer_friend_title"].waitForExistence(timeout: 5))
		
		let friendEmailTextField = app.textFields.containing(NSPredicate(format: "identifier CONTAINS 'friend_email'"))
		XCTAssertEqual(friendEmailTextField.count, 1)
		
		XCTAssertTrue(app.staticTexts["Add a comma after each email address."].exists)
		XCTAssertTrue(app.staticTexts["Share Invite"].exists)
		XCTAssertTrue(app.staticTexts["COPY"].exists)
		
		let referralCode = app.staticTexts.containing(NSPredicate(format: "identifier CONTAINS 'referral_code'"))
		XCTAssertEqual(referralCode.count, 1)
		
		XCTAssertTrue(app.buttons["Done"].exists)
		XCTAssertTrue(app.buttons["ic-forward"].exists)
		XCTAssertTrue(app.buttons["ic-fb"].exists)
		XCTAssertTrue(app.buttons["ic-ig"].exists)
		XCTAssertTrue(app.buttons["ic-whatsapp"].exists)
		XCTAssertTrue(app.buttons["ic-twitter"].exists)
		XCTAssertTrue(app.buttons["ic-share"].exists)
	}
}
