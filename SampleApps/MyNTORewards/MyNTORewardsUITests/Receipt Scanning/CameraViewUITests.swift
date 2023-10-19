//
//  CameraViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 07/08/23.
//

import XCTest

final class CameraViewUITests: XCTestCase {
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
	
	func testElements() {
		ReceiptsViewHelper.goToCameraView(app: app)
		XCTAssert(app.buttons["close_camera_button"].exists)
		XCTAssert(app.buttons["Flash Off"].exists)
		XCTAssert(app.buttons["camera_shutter_button"].exists)
		XCTAssert(app.buttons["choose_from_photos"].exists)
		XCTAssert(app.staticTexts["Click or Upload the Receipt"].exists)
	}
	
	func testFlash() {
		ReceiptsViewHelper.goToCameraView(app: app)
		
		app.buttons["Flash Off"].tap()
		XCTAssert(app.buttons["Flash"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash Off"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash Auto"].waitForExistence(timeout: 3))
		
		app.buttons["Flash"].tap()
		XCTAssert(app.buttons["Flash Auto"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash Off"].waitForExistence(timeout: 3))
		
		app.buttons["Flash Auto"].tap()
		XCTAssert(app.buttons["Flash Off"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash"].waitForExistence(timeout: 3))
		XCTAssertFalse(app.buttons["Flash Auto"].waitForExistence(timeout: 3))
	}
	
	func testCloseButton() {
		ReceiptsViewHelper.goToCameraView(app: app)
		XCTAssert(app.buttons["close_camera_button"].waitForExistence(timeout: 3))
		app.buttons["close_camera_button"].tap()
		// TODO:- Camera view is not closing on tapping close button
		XCTAssertFalse(app.buttons["camera_shutter_button"].waitForExistence(timeout: 3))
	}
	
	func testChooseFromPhotos() {
		ReceiptsViewHelper.goToCameraView(app: app)
		app.buttons["choose_from_photos"].tap()
		XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["Photos"].waitForExistence(timeout: 3))
		XCTAssert(app.buttons["Albums"].waitForExistence(timeout: 3))
	}

}
