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
		XCTAssert(app.staticTexts["submit_receipt"].exists)
		XCTAssert(app.staticTexts["receipt_number_label"].exists)
		XCTAssert(app.staticTexts["store_label"].exists)
		XCTAssert(app.staticTexts["receipt_date"].exists)
		XCTAssert(app.buttons["Try Again"].exists)
	}
	
	func testSubmitReceipt() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		app.staticTexts["submit_receipt"].tap()
		XCTAssert(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 10))
		XCTAssertFalse(app.staticTexts["submit_receipt"].exists)
	}
	
	func testTryAgain() {
		ReceiptsViewHelper.goToProcessedReceiptView(app: app)
		app.buttons["Try Again"].tap()
		XCTAssert(app.buttons["camera_shutter_button"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.staticTexts["submit_receipt"].exists)
	}
	
}
