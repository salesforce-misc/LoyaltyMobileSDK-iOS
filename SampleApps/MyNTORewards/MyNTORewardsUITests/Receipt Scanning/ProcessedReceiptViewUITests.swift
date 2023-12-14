//
//  ProcessedReceiptViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 07/08/23.
//

import XCTest

final class ProcessedReceiptViewUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testProcessedReceiptViewElements() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		XCTAssert(app.staticTexts["receipt_number_label"].exists)
		XCTAssert(app.staticTexts["store_label"].exists)
		XCTAssert(app.staticTexts["receipt_date"].exists)
		XCTAssert(app.staticTexts["Item"].exists)
		XCTAssert(app.staticTexts["Quantity"].exists)
		XCTAssert(app.staticTexts["Unit Price"].exists)
		XCTAssert(app.staticTexts["Total"].exists)
		XCTAssert(app.buttons["Try Again"].exists)
		XCTAssert(app.buttons["submit_receipt"].exists)
	}
	
	func testSubmitReceipt() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		app.buttons["submit_receipt"].tap()
		XCTAssert(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 10))
		XCTAssertFalse(app.buttons["submit_receipt"].exists)
	}
	
	func testTryAgain() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		app.buttons["Try Again"].tap()
		XCTAssert(app.buttons["camera_shutter_button"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["submit_receipt"].exists)
	}
	
	func testRequestForManualReview() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		XCTAssert(app.buttons["Request a Manual Review"].waitForExistence(timeout: 3))
		app.buttons["Request a Manual Review"].tap()
		XCTAssert(app.staticTexts["Manual review"].waitForExistence(timeout: 3))
	}
	
	func testReceiptWithInvalidDateFormat() {
		ReceiptsViewHelper.receiptType = .invalidDateFormat
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		XCTAssert(app.staticTexts["Specify the COSTCO SAL’s date format in the Accepted Date Format custom metadata type."].waitForExistence(timeout: 4))
	}
	
	func testReceiptWithOnlyIneligibleItems() {
		ReceiptsViewHelper.receiptType = .onlyIneligible
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		XCTAssert(app.staticTexts["no_eligible_items_found"].waitForExistence(timeout: 4))
		XCTAssert(app.staticTexts["Ineligible Items"].waitForExistence(timeout: 4))
	}
}
