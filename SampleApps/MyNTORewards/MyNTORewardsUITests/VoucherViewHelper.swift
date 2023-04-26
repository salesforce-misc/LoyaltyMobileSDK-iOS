//
//  VoucherViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 24/04/23.
//

import XCTest

final class VoucherViewHelper {
    static let app = XCUIApplication()
    
    static func testVoucherScreens() {
        
    }
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
        XCTAssertTrue(app.staticTexts["Available"].exists)
        XCTAssertTrue(app.staticTexts["Redeemed"].exists)
        XCTAssertTrue(app.staticTexts["Expired"].exists)
        XCTAssertTrue(app.staticTexts["You have no Available Vouchers"].exists)
        app.staticTexts["Redeemed"].tap()
        XCTAssertTrue(app.staticTexts["Nothing to report"].exists)
        XCTAssertTrue(app.staticTexts["After you redeem a voucher, you’ll find it here."].exists)
        app.staticTexts["Expired"].tap()
        XCTAssertTrue(app.staticTexts["You have no Expired Vouchers"].exists)
    }
}
