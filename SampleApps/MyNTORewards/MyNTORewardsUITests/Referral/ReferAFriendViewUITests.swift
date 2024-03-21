//
//  ReferAFriendViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 01/02/24.
//

import XCTest

final class ReferAFriendViewUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
		ReferralViewHelper.goToReferAFriendView(app: app)
	}
	
	func test_UIElements() {
		XCTAssertTrue(app.staticTexts["refer_friend_title"].waitForExistence(timeout: 5))
		let referAFriendDescription = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Invite your friends and get a voucher'"))
		XCTAssertEqual(referAFriendDescription.count, 1)
		
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
	
	func test_tappingDismissButton_shouldDismissReferAFriendView() {
		app.images["ic-dismiss"].tap()
		XCTAssertFalse(app.staticTexts["Start Referring"].waitForExistence(timeout: 2))
	}
	
	func test_sendingReferralThroughEmail() {
		let textField = app.textFields["friend_email"]
		textField.tap()
		textField.typeText("test@test.com")
		app.buttons["ic-forward"].tap()
		XCTAssertTrue(app.alerts["Email Sent"].waitForExistence(timeout: 5))
	}
	
	func test_sendingReferralThroughInvalidEmail_shouldShowError() {
		let textField = app.textFields["friend_email"]
		textField.tap()
		textField.typeText("test@test")
		app.buttons["ic-forward"].tap()
		XCTAssertTrue(app.staticTexts["Something doesn't look right with one of the email addresses."].exists)
	}
	
	func test_tappingThirdPartySenders_shouldShowShareView() {
		app.buttons["ic-fb"].tap()
		validateShareViewExistence()
		app.buttons["Close"].tap()
		
		app.buttons["ic-ig"].tap()
		validateShareViewExistence()
		app.buttons["Close"].tap()
		
		app.buttons["ic-share"].tap()
		validateShareViewExistence()
		app.buttons["Close"].tap()
	}
	
	func test_sendThroughWhatsApp_shouldShowShareView() {
		app.buttons["ic-whatsapp"].tap()
		validateShareViewExistence()
		app.buttons["Close"].tap()
	}
	  
	func test_sendthroughTwitter_shouldOpenSafariWithTwitter() {
		app.buttons["ic-twitter"].tap()
		let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
		XCTAssertTrue(safari.wait(for: .runningForeground, timeout: 30))
		safari.textFields["Address"].tap()
		let url = safari.textFields["Address"].value as? String
		XCTAssertNotNil(url)
		XCTAssertTrue(url!.contains("twitter"))
	}
	
	private func validateShareViewExistence() {
		let referralMessageLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Use my referral link to sign up'"))
		XCTAssertEqual(referralMessageLabel.count, 1)
		XCTAssertTrue(app.staticTexts["Messages"].exists)
		XCTAssertTrue(app.staticTexts["Copy"].exists)
	}
	
	func test_tappingCopyButton_shouldCopyCodeAndShowAlert() {
        app.buttons["ic-copyLink"].tap()
		XCTAssertTrue(app.alerts["Referral code copied"].exists)
		app.textFields["friend_email"].tap()
		app.textFields["friend_email"].tap()
		app.staticTexts["Paste"].tap()
		let friendEmailTextField = app.textFields.containing(NSPredicate(format: "value CONTAINS '?referralCode='"))
		XCTAssertEqual(friendEmailTextField.count, 1)
	}
	
	func test_tappingDoneButton_shouldDismissView() {
		app.buttons["Done"].tap()
		XCTAssertFalse(app.staticTexts["Start Referring"].exists)
	}
}
