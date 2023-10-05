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
		XCTAssert(app.staticTexts["Item"].exists)
		XCTAssert(app.staticTexts["Quantity"].exists)
		XCTAssert(app.staticTexts["Unit Price"].exists)
		XCTAssert(app.staticTexts["Total"].exists)
		XCTAssert(app.staticTexts["Eligible Items"].exists)
		XCTAssert(app.staticTexts["Receipt Image"].exists)
	}
	
	func testRequestManualReviewButton() {
		ReceiptsViewHelper.goToReceiptDetailsView(app: app)
        if app.collectionViews.staticTexts["Request a Manual Review"].waitForExistence(timeout: 3) {
            app.buttons["Request a Manual Review"].tap()
            XCTAssert(app.staticTexts["Manual review"].waitForExistence(timeout: 3))
            XCTAssertFalse(app.buttons["Submit"].waitForExistence(timeout: 3))
        }		
	}

	func testTab() {
		ReceiptsViewHelper.goToReceiptDetailsView(app: app)
		XCTAssert(app.staticTexts["Receipt Image"].waitForExistence(timeout: 2))
		app.staticTexts["Receipt Image"].tap()
		XCTAssert(app.images.element.waitForExistence(timeout: 2))
		XCTAssertFalse(app.staticTexts["Item"].waitForExistence(timeout: 2))
		app.staticTexts["Receipt Items"].tap()
		XCTAssert(app.staticTexts["Item"].waitForExistence(timeout: 2))
		XCTAssert(app.staticTexts["Quantity"].exists)
	}
    
    func testtDownloadReceiptButton() {
        ReceiptsViewHelper.goToReceiptDetailsView(app: app)
        XCTAssert(app.staticTexts["Receipt Image"].waitForExistence(timeout: 2))
        app.staticTexts["Receipt Image"].tap()
        XCTAssert(app.buttons["Download Original Receipt"].waitForExistence(timeout: 3))
    }
	
}
