//
//  ReceiptsViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 05/08/23.
//

import XCTest

final class ReceiptsViewUITests: XCTestCase {
	let app = XCUIApplication()
	
    override func setUpWithError() throws {
        continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launch()
		addUIInterruptionMonitor(withDescription: "myNTO lewards Would Like to Access Your Photos") { (element) -> Bool in
			let keepCurrent = element.buttons["Keep Current Selection"].firstMatch
			if element.elementType == .alert && keepCurrent.exists {
				keepCurrent.tap()
				return true
			} else {
				return false
			}
		}
    }
	
	func testUIElements() {
		ReceiptsViewHelper.goToReceiptsView(app: app)
		XCTAssert(app.buttons["back_button"].exists)
		XCTAssert(app.textFields["receipts_search_bar"].exists)
		XCTAssert(app.buttons["new_button"].exists)
		XCTAssert(app.cells.element.waitForExistence(timeout: 5))
		XCTAssert(app.staticTexts["Receipts"].exists)
	}
	
	/// Tapping 'New' and verifying if Flash button is appearing to confirm Camera view is open
	func testNewButtonAction() {
		ReceiptsViewHelper.goToReceiptsView(app: app)
		app.buttons["new_button"].tap()
		XCTAssert(app.buttons["Flash Off"].waitForExistence(timeout: 5))
	}
	
	/// Tapping on search field and enetering invalid receipt number to verify the list is empty
	func testSearch() {
		ReceiptsViewHelper.goToReceiptsView(app: app)
		let searchField = app.textFields["receipts_search_bar"]
		searchField.tap()
		XCTAssert(app.cells.element.exists)
		searchField.typeText("000000")
		app.keyboards.buttons["Return"].tap()
		XCTAssertFalse(app.cells.element.exists)
	}
	
	/// Tapping back button and verifying if receipt view elements are not present
	func testBackButton() {
		ReceiptsViewHelper.goToReceiptsView(app: app)
		app.buttons["back_button"].tap()
		XCTAssertFalse(app.buttons["new_button"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["receipts_search_bar"].waitForExistence(timeout: 3))
	}
	
	func testShowCapturedImageView() {
		ReceiptsViewHelper.goToCapturedImageView(app: app)
		XCTAssert(app.buttons["process_button"].waitForExistence(timeout: 3))
	}
	
}
