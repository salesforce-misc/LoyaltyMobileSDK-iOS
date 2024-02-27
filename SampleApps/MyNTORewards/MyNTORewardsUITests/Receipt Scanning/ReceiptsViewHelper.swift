//
//  ReceiptsViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import XCTest

final class ReceiptsViewHelper {
	
	enum ReceiptType {
		case eligibleAndIneligible
		case onlyEligible
		case onlyIneligible
		case invalidDateFormat
	}
	
	static var receiptType: ReceiptType = .eligibleAndIneligible
	
	static private func getImageLabel() -> String {
		switch receiptType {
		case .eligibleAndIneligible:
			return "Photo, 05 October, 4:00 PM"
		case .invalidDateFormat:
			return "Photo, 14 November, 5:38 PM"
		case .onlyIneligible:
			return "Photo, 14 November, 4:56 PM"
		default:
			return "Photo, 05 October, 4:00 PM"
		}
	}

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
		let predicate = NSPredicate(format: "label BEGINSWITH '\(getImageLabel())'")
		let receipt = app.scrollViews.otherElements.images.containing(predicate).element
		XCTAssert(receipt.waitForExistence(timeout: 4))
		receipt.tap()
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
