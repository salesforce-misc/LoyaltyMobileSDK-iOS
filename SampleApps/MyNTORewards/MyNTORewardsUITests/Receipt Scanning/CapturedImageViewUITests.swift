//
//  CaptureImageViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 07/08/23.
//

import XCTest

final class CapturedImageViewUITests: XCTestCase {

	let app = XCUIApplication()
	
    override func setUpWithError() throws {
        continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
    }
	
	func testCapturedImageViewElements() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		XCTAssert(app.buttons["process_button"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["back_button_captured_image_view"].waitForExistence(timeout: 3))
		XCTAssert(app.staticTexts["Try Again"].waitForExistence(timeout: 3))
	}
	
	func testProcessButton() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		XCTAssert(app.buttons["process_button"].waitForExistence(timeout: 3))
		app.buttons["process_button"].tap()
		XCTAssert(app.staticTexts["scanning_receipt"].waitForExistence(timeout: 1))
	}
	
	func testTryAgainButton() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		app.staticTexts["Try Again"].tap()
		XCTAssertFalse(app.buttons["process_button"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["camera_shutter_button"].exists)
	}
	
	func testBackButton() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		app.buttons["back_button_captured_image_view"].tap()
		XCTAssertFalse(app.buttons["process_button"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["camera_shutter_button"].exists)
	}
	
	func testImage() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		XCTAssert(app.images.element.waitForExistence(timeout: 3))
	}
}
