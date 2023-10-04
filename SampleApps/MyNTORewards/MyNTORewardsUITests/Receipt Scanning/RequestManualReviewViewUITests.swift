//
//  RequestManualReviewViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 09/08/23.
//

import XCTest

final class RequestManualReviewViewUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testUIElements() {
		ReceiptsViewHelper.goToRequestManualReviewView(app: app)
		XCTAssert(app.staticTexts["receipt_number_text"].waitForExistence(timeout: 3))
		XCTAssert(app.staticTexts["receipt_date_text"].exists)
		XCTAssert(app.staticTexts["receipt_amount_text"].exists)
		XCTAssert(app.staticTexts["receipt_points_text"].exists)
		XCTAssert(app.staticTexts["Submit"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["close_button"].exists)
		XCTAssert(app.buttons["Cancel"].exists)
	}
	
	func testCloseButton() {
		ReceiptsViewHelper.goToRequestManualReviewView(app: app)
		XCTAssert(app.buttons["close_button"].waitForExistence(timeout: 3))
		app.buttons["close_button"].tap()
		XCTAssertFalse(app.buttons["Submit"].waitForExistence(timeout: 3))
	}
	
	func testSubmitForManualReviewButton() {
		ReceiptsViewHelper.goToRequestManualReviewView(app: app)
		XCTAssert(app.staticTexts["Submit"].waitForExistence(timeout: 3))
		app.staticTexts["Submit"].tap()
		XCTAssertFalse(app.staticTexts["Submit"].waitForExistence(timeout: 3))
		
	}
	
	func testBackButton() {
		ReceiptsViewHelper.goToRequestManualReviewView(app: app)
		XCTAssert(app.buttons["back_button_in_manual_review"].waitForExistence(timeout: 3))
		app.buttons["back_button_in_manual_review"].tap()
		XCTAssert(app.buttons["Request a Manual Review"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.staticTexts["Submit for Manual Review"].waitForExistence(timeout: 3))
	}
}
