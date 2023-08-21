//
//  ReceiptCongratsViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 07/08/23.
//

import XCTest

final class ReceiptCongratsViewUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testCongratsViewElements() {
		ReceiptsViewHelper.goToReceiptCongratsView(app: app)
		XCTAssert(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 3))
		XCTAssert(app.staticTexts["Done"].exists)
		XCTAssert(app.buttons["scan_another_receipt"].exists)
	}
	
	func testDoneButton() {
		ReceiptsViewHelper.goToReceiptCongratsView(app: app)
		app.staticTexts["Done"].tap()
		XCTAssertFalse(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 3))
	}
	
	func testScanAnotherReceipt() {
		ReceiptsViewHelper.goToReceiptCongratsView(app: app)
		app.buttons["scan_another_receipt"].tap()
		XCTAssertFalse(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["camera_shutter_button"].exists)
	}
}
