//
//  VoucherViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 24/04/23.
//

import XCTest

final class VoucherViewHelper {
    static let app = XCUIApplication()
    
    static func testVoucherElements() throws {
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
        XCTAssertTrue(app.staticTexts["Available"].exists)
        XCTAssertTrue(app.staticTexts["Redeemed"].exists)
        XCTAssertTrue(app.staticTexts["Expired"].exists)
    }
    
    static func testEmptyViewElements() throws {
        try testVoucherElements()
        XCTAssertTrue(app.staticTexts["You have no Available Vouchers"].exists)
        app.staticTexts["Redeemed"].tap()
        XCTAssertTrue(app.staticTexts["Nothing to report"].exists)
        XCTAssertTrue(app.staticTexts["After you redeem a voucher, you’ll find it here."].exists)
        app.staticTexts["Expired"].tap()
        XCTAssertTrue(app.staticTexts["You have no Expired Vouchers"].exists)
    }
    
    static func testVoucherDetailView() throws {
        XCTAssertTrue(app.staticTexts["name"].exists)
        XCTAssertTrue(app.images["image"].exists)
        XCTAssertTrue(app.images["qr_code"].exists)
        XCTAssertTrue(app.staticTexts["voucher_code"].exists)
        XCTAssertTrue(app.images["dismiss_button"].exists)
        XCTAssertTrue(app.buttons["close_button"].exists)
        app.buttons["close_button"].tap()
    }
    
    static func testVoucherCardView() throws {
        for i in 0..<2 {
            guard app.images["voucher_\(i)_image"].waitForExistence(timeout: 5) else {
                return
            }
            XCTAssertTrue(app.staticTexts["voucher_\(i)_name"].exists)
            XCTAssertTrue(app.staticTexts["voucher_\(i)_status"].exists)
            XCTAssertTrue(app.staticTexts["voucher_\(i)_end_date"].exists)
            app.images["voucher_\(i)_image"].tap()
            try testVoucherDetailView()
        }
    }
    
    static func testVoucherView() throws {
        app.staticTexts["Available"].tap()
        try testVoucherCardView()
        app.staticTexts["Redeemed"].tap()
        try testVoucherCardView()
        app.staticTexts["Expired"].tap()
        try testVoucherCardView()
    }
    
    static func testVoucherScreen() throws {
        app.swipeUp()
        app.buttons["My Vouchers View All"].tap()
        try testVoucherElements()
        try testVoucherView()
        app.buttons["back_button"].tap()
    }
    
    static func testVoucherEmptyScreen() throws {
        app.swipeUp()
        app.buttons["My Vouchers View All"].tap()
        try VoucherViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
    }
}
