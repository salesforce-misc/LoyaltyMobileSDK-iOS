//
//  HomeViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class HomeViewHelper: XCTestCase {
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["username_label"].exists)
        XCTAssertTrue(app.staticTexts["reward_points_label"].exists)
        XCTAssertTrue(app.staticTexts["promotion_header"].exists)
        XCTAssertTrue(app.staticTexts["view_all"].exists)
        XCTAssertTrue(app.staticTexts["You do not have any eligibile promotions to enroll. Please come back later."].exists)
        XCTAssertTrue(app.staticTexts["No Promotions, yet."].exists)
        XCTAssertTrue(app.staticTexts["You have no Vouchers Available"].exists)
        XCTAssertTrue(app.staticTexts["View All"].exists)
        XCTAssertTrue(app.staticTexts["My Vouchers"].exists)
    }
    
    static func testPromotionViewElements() throws {
        app.staticTexts["view_all"].tap()
        try PromotionViewHelper.testEmptyViewElements()
        app.tabBars.buttons["Home"].tap()
        try  testEmptyViewElements()
    }
    
    static func testVoucherViewElements() throws {
        app.buttons["My Vouchers View All"].tap()
        try VoucherViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try  testEmptyViewElements()
    }
}
