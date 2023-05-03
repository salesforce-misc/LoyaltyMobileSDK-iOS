//
//  MoreViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class MoreViewHelper {
    static let app = XCUIApplication()
    
    static func testMoreScreen() throws {
        app.tabBars.buttons["More"].tap()
        try testAllElements()
        try testLogOut()
    }
    
    static func testAllElements() throws {
        XCTAssertTrue(app.staticTexts["account_label"].exists)
        XCTAssertTrue(app.staticTexts["address_label"].exists)
        XCTAssertTrue(app.staticTexts["paymentMethod_label"].exists)
        XCTAssertTrue(app.staticTexts["orders_label"].exists)
        XCTAssertTrue(app.staticTexts["support_label"].exists)
        XCTAssertTrue(app.staticTexts["favourites_label"].exists)
    }
    
    static func testLogOut() throws {
        app.buttons["logout_button"].tap()
        
        XCTAssertTrue(app.buttons["login_button"].waitForExistence(timeout: 1))
        try OnBoardingViewHelper.testOnboardingElements()
    }
}
