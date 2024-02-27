//
//  ReceiptScanningFromHomeScreenTests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 11/08/23.
//

import XCTest

final class ReceiptScanningFromHomeScreenTests: XCTestCase {
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
	}
	
	func testReceiptsButton() {
		app.tabBars.buttons["Home"].tap()
		app.images["receipts_icon"].tap()
        XCTAssert(app.staticTexts["new_button"].exists)
        app.staticTexts["new_button"].tap()
		XCTAssert(app.buttons["camera_shutter_button"].exists)
	}
	
	func testHappyPath() {
		app.tabBars.buttons["Home"].tap()
		app.images["receipts_icon"].tap()
        XCTAssert(app.staticTexts["new_button"].exists)
        app.staticTexts["new_button"].tap()
		XCTAssert(app.buttons["camera_shutter_button"].exists)
		app.buttons["choose_from_photos"].tap()
        _ = app.staticTexts["photos"].waitForExistence(timeout: 3)
		let predicate = NSPredicate(format: "label BEGINSWITH 'Photo, 05 October, 4:00 PM'")
		let receipt = app.scrollViews.otherElements.images.containing(predicate).element
		XCTAssert(receipt.waitForExistence(timeout: 4))
		receipt.tap()
		_ = app.buttons["process_button"].waitForExistence(timeout: 3)
		app.buttons["process_button"].tap()
		_ = app.buttons["submit_receipt"].waitForExistence(timeout: 30)
		app.buttons["submit_receipt"].tap()
		XCTAssert(app.staticTexts["receipt_submitted_congrats"].waitForExistence(timeout: 15))
		XCTAssert(app.buttons["Done"].exists)
	}
}
