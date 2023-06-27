//
//  MyProfileViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class MyProfileViewHelper: XCTestCase {
    static let app = XCUIApplication()
    
    static func testProfileScreenElements() throws {
        XCTAssertTrue(app.staticTexts["profile_header"].exists)
        XCTAssertTrue(app.staticTexts["user_name_label"].exists)
        XCTAssertTrue(app.staticTexts["userid_label"].exists)
        XCTAssertTrue(app.staticTexts["tier_name_label"].exists)
        XCTAssertTrue(app.staticTexts["reward_points_label"].exists)
        XCTAssertTrue(app.staticTexts["reward_points"].exists)
        XCTAssertTrue(app.images["profile_image"].exists)
        XCTAssertTrue(app.buttons["qrcode"].exists)
        XCTAssertTrue(app.staticTexts["My Transactions"].exists)
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
        XCTAssertTrue(app.staticTexts["My Benefits"].exists)
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
    }
    
    static func testEmptyViewElements() throws {
        try testProfileScreenElements()
        XCTAssertTrue(app.staticTexts["You have no Transactions"].exists)
        XCTAssertTrue(app.staticTexts["You have no Vouchers Available"].exists)
        XCTAssertTrue(app.staticTexts["You have no Benefits"].exists)
    }
    
    static func testQRScreen() throws {
        app.buttons["qrcode"].tap()
        try testQRScreenElements()
        
        app.images["close_image"].tap()
        try testProfileScreenElements()
        
        app.buttons["qrcode"].tap()
        try testQRScreenElements()
        
        app.buttons["close_button"].tap()
        try testProfileScreenElements()
    }
    
    static func testQRScreenElements() throws {
        XCTAssertTrue(app.staticTexts["qr_title"].exists)
        XCTAssertTrue(app.staticTexts["user_name"].exists)
        XCTAssertTrue(app.staticTexts["membership_number"].exists)
        XCTAssertTrue(app.staticTexts["qr_code_label"].exists)
        XCTAssertTrue(app.staticTexts["qr_description"].exists)
        XCTAssertTrue(app.images["close_image"].exists)
        XCTAssertTrue(app.images["profile_image"].exists)
        XCTAssertTrue(app.images["qr_image"].exists)
        XCTAssertTrue(app.buttons["close_button"].exists)
    }
}
