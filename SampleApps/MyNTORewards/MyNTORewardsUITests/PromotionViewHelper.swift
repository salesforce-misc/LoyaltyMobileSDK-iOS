//
//  PromotionViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class PromotionViewHelper {
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() {
        XCTAssertTrue(app.staticTexts["promotion_header"].exists)
        XCTAssertTrue(app.images["search_image"].exists)
        XCTAssertTrue(app.staticTexts["Unenrolled"].exists)
        XCTAssertTrue(app.staticTexts["Active"].exists)
        XCTAssertTrue(app.staticTexts["All"].exists)
        XCTAssertTrue(app.staticTexts["You do not have any eligibile promotions to enroll. Please come back later."].exists)
        XCTAssertTrue(app.staticTexts["No Promotions, yet."].exists)
    }
}
