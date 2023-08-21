//
//  ReceiptDetailsUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 09/08/23.
//

import XCTest

final class ReceiptDetailsUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testReceiptDetailsViewUIElements() {
		ReceiptsViewHelper.goToReceiptDetailsView(app: app)
		
		XCTAssert(app.staticTexts["receipt_number_text"].waitForExistence(timeout: 3))
		XCTAssert(app.staticTexts["receipt_date_text"].exists)
		XCTAssert(app.staticTexts["receipt_amount_text"].exists)
		XCTAssert(app.staticTexts["receipt_points_text"].exists)
		XCTAssert(app.staticTexts["Item name"].exists)
		XCTAssert(app.staticTexts["Qty"].exists)
		XCTAssert(app.staticTexts["Price"].exists)
		XCTAssert(app.staticTexts["Total"].exists)
		XCTAssert(app.buttons["Request a Manual Review"].exists)
		XCTAssert(app.buttons["Download"].exists)
		XCTAssert(app.buttons["close_button"].exists)
	}
	
	func testRequestManualReviewButton() {
		ReceiptsViewHelper.goToReceiptDetailsView(app: app)
		XCTAssert(app.buttons["Request a Manual Review"].waitForExistence(timeout: 3))
		app.buttons["Request a Manual Review"].tap()
		XCTAssert(app.staticTexts["Submit for Manual Review"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Request a Manual Review"].waitForExistence(timeout: 3))
	}
	
	func testCloseButton() {
		ReceiptsViewHelper.goToReceiptDetailsView(app: app)
		XCTAssert(app.buttons["close_button"].waitForExistence(timeout: 3))
		app.buttons["close_button"].tap()
		XCTAssertFalse(app.buttons["Request a Manual Review"].waitForExistence(timeout: 3))
	}
	
}
