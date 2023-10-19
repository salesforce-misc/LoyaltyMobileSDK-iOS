//
//  ReceiptsViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import XCTest

final class ReceiptsViewHelper {

	static func goToReceiptsView(app: XCUIApplication) {
		app.tabBars.buttons["More"].tap()
		app.buttons["Receipts"].tap()
	}
	
	static func goToCameraView(app: XCUIApplication) {
		goToReceiptsView(app: app)
		app.staticTexts["new_button"].tap()
	}
	
	static func goToCapturedImageView(app: XCUIApplication) {
		goToCameraView(app: app)
		app.buttons["choose_from_photos"].tap()
		XCTAssert(app.collectionViews.cells.element(boundBy: 0).waitForExistence(timeout: 4))
		app.collectionViews.cells.element(boundBy: 0).tap()
	}
	
	static func goToProcessingReceiptView(app: XCUIApplication) {
		goToCapturedImageView(app: app)
		_ = app.buttons["process_button"].waitForExistence(timeout: 3)
		app.buttons["process_button"].tap()
	}
	
	static func goToProcessedReceiptView(app: XCUIApplication) {
		goToProcessingReceiptView(app: app)
		_ = app.buttons["submit_receipt"].waitForExistence(timeout: 15)
	}
	
	static func goToReceiptCongratsView(app: XCUIApplication) {
		goToProcessedReceiptView(app: app)
		app.buttons["submit_receipt"].tap()
	}
	
	static func goToReceiptDetailsView(app: XCUIApplication) {
		goToReceiptsView(app: app)
		_ = app.cells.element.waitForExistence(timeout: 5)
		app.cells.element(boundBy: 0).tap()
	}
    
    static func goToReceiptDetailsViewBasedOnReviewStatus(app: XCUIApplication, isHavePoints: Bool) {
        goToReceiptsView(app: app)
        _ = app.cells.element.waitForExistence(timeout: 5)
        app.cells.containing(.staticText, identifier: isHavePoints ? "receipt_points_text":"receipt_manual_review_text").firstMatch.tap()
    }
	
	static func goToRequestManualReviewView(app: XCUIApplication) {
		goToReceiptsView(app: app)
		_ = app.cells.element.waitForExistence(timeout: 5)
        let cellWithOutManualReviewCell = app.cells.containing(.staticText, identifier: "receipt_points_text").firstMatch
        cellWithOutManualReviewCell.tap()
		_ = app.buttons["Request a Manual Review"].waitForExistence(timeout: 3)
		app.buttons["Request a Manual Review"].tap()
	}
}
