//
//  PromotionViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class PromotionViewHelper {
    static let app = XCUIApplication()
    
    static func testAllElements() throws {
        XCTAssertTrue(app.staticTexts["promotion_header"].exists)
        XCTAssertTrue(app.images["search_image"].exists)
        XCTAssertTrue(app.staticTexts["Unenrolled"].exists)
        XCTAssertTrue(app.staticTexts["Active"].exists)
        XCTAssertTrue(app.staticTexts["All"].exists)
    }
    
    static func testEmptyViewElements() throws {
        try testAllElements()
        XCTAssertTrue(app.staticTexts["You do not have any eligibile promotions to enroll. Please come back later."].exists)
        XCTAssertTrue(app.staticTexts["No Promotions, yet."].exists)
        app.staticTexts["Active"].tap()
        XCTAssertTrue(app.staticTexts["No Promotions, yet."].exists)
        XCTAssertTrue(app.staticTexts["You do not have any active promotions. Please come back later."].exists)
        app.staticTexts["All"].tap()
        XCTAssertTrue(app.staticTexts["No Promotions, yet."].exists)
        XCTAssertTrue(app.staticTexts["You do not have any eligibile promotions. Please come back later."].exists)
    }
    
    static func testPromotionDetailView() throws {
        XCTAssertTrue(app.staticTexts["name"].exists)
        XCTAssertTrue(app.staticTexts["description"].exists)
        XCTAssertTrue(app.images["image"].exists)
        if app.buttons["join_button"].exists {
            XCTAssertTrue(app.buttons["join_button"].exists)
        } else {
            XCTAssertTrue(app.buttons["shop_button"].exists)
        }
        XCTAssertTrue(app.images["dismiss_button"].exists)
        app.images["dismiss_button"].tap()
    }
    
    static func testPromotionView() throws {
        try testAllElements()
        app.staticTexts["Unenrolled"].tap()
        try testPromotionCardView()
        app.staticTexts["Active"].tap()
        try testPromotionCardView()
        app.staticTexts["All"].tap()
        try testPromotionCardView()
    }
    
    static func testPromotionCardView(swipeLeft: Bool = false) throws {
        for i in 0..<4 {
            guard app.images["promotion_\(i)_image"].waitForExistence(timeout: 5) else {
                break
            }
            XCTAssertTrue(app.staticTexts["promotion_\(i)_name"].exists)
            XCTAssertTrue(app.staticTexts["promotion_\(i)_description"].exists)
            app.images["promotion_\(i)_image"].tap()
            try testPromotionDetailView()
            if swipeLeft {
                app.swipeLeft()
            }
        }
    }
    
    static func testPromotionCardReverse() throws {
        for i in (0..<4).reversed() {
            guard app.images["promotion_\(i)_image"].waitForExistence(timeout: 5) else {
                continue
            }
            XCTAssertTrue(app.staticTexts["promotion_\(i)_name"].exists)
            XCTAssertTrue(app.staticTexts["promotion_\(i)_description"].exists)
            app.images["promotion_\(i)_image"].tap()
            try testPromotionDetailView()
            app.swipeRight()
        }
    }
    
    static func testPromotionCarousalView() throws {
        XCTAssertTrue(app.staticTexts["promotion_header"].exists)
        try testPromotionCardView(swipeLeft: true)
        try testPromotionCardReverse()
    }
}
