//
//  ProcessingImageViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 07/08/23.
//

import XCTest

final class ProcessingReceiptViewUITests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testProcessingReceiptViewElements() {
		ReceiptsViewHelper.goToProcessingReceiptView(app: app)
		XCTAssert(app.staticTexts["scanning_receipt"].exists)
		XCTAssert(app.staticTexts["scanning_receipt_subtitle"].exists)
		XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 1))
	}
	
	func testCancel() {
		ReceiptsViewHelper.goToProcessingReceiptView(app: app)
		_ = app.buttons["Cancel"].waitForExistence(timeout: 3)
		app.buttons["Cancel"].tap()
		XCTAssertFalse(app.staticTexts["scanning_receipt"].waitForExistence(timeout: 3))
	}
	
	func testProcessingCompletes() {
		ReceiptsViewHelper.goToProcessingReceiptView(app: app)
		XCTAssert(app.staticTexts["Submit Receipt"].waitForExistence(timeout: 15))
	}
}
