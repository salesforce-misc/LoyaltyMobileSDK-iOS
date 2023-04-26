//
//  MyProfileViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class MyProfileViewHelper: XCTestCase {
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["profile_header"].exists)
        XCTAssertTrue(app.staticTexts["user_name_label"].exists)
        XCTAssertTrue(app.staticTexts["userid_label"].exists)
        XCTAssertTrue(app.staticTexts["tier_name_label"].exists)
        XCTAssertTrue(app.staticTexts["reward_points_label"].exists)
        XCTAssertTrue(app.staticTexts["reward_points"].exists)
        XCTAssertTrue(app.images["profile_image"].exists)
        XCTAssertTrue(app.staticTexts["My Transactions"].exists)
        XCTAssertTrue(app.staticTexts["You have no Transactions"].exists)
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
        XCTAssertTrue(app.staticTexts["You have no Vouchers Available"].exists)
        XCTAssertTrue(app.staticTexts["My Benefits"].exists)
        XCTAssertTrue(app.staticTexts["You have no Benefits"].exists)
        XCTAssertTrue(app.buttons["qrcode"].exists)
    }
    
    static func testQRScreen() throws {
        app.buttons["qrcode"].tap()
        try testQRScreenElements()
        
        app.images["close_image"].tap()
        try testEmptyViewElements()
        
        app.buttons["qrcode"].tap()
        try testQRScreenElements()
        
        app.buttons["close_button"].tap()
        try testEmptyViewElements()
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
    
    static func testVoucherScreen() throws {
        app.swipeUp()
        app.buttons["My Vouchers View All"].tap()
        try VoucherViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try  testEmptyViewElements()
    }
    
    static func testBenefitsScreen() throws {
        app.buttons["My Benefits View All"].tap()
        try BenefitsViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try testEmptyViewElements()
    }
    
    static func testTransactionsScreen() throws {
        app.buttons["My Transactions View All"].tap()
        try TransactionsViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try testEmptyViewElements()
    }
}
