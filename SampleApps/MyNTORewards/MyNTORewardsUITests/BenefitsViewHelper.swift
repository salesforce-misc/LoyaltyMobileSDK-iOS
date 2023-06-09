//
//  BenefitsViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 24/04/23.
//

import XCTest

final class BenefitsViewHelper {
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["My Benefits"].exists)
        XCTAssertTrue(app.staticTexts["You have no Benefits"].exists)
    }
    
    static func testBenefitsView() throws {
        XCTAssertTrue(app.staticTexts["My Benefits"].exists)
        XCTAssertTrue(app.staticTexts["My Benefits view All"].exists)
    }
    
    static func testBenefitCardView() throws {
        for i in 0..<5 {
            guard app.images["benefit_\(i)_logo"].waitForExistence(timeout: 2) else {
                return
            }
            XCTAssertTrue(app.staticTexts["benefit_\(i)_name"].exists)
        }
    }
    
    static func testBenefitScreen() throws {
        app.buttons["My Benefits View All"].tap()
        XCTAssertTrue(app.staticTexts["My Benefits"].exists)
        XCTAssertTrue(app.buttons["back_button"].exists)
        try testBenefitCardView()
        app.buttons["back_button"].tap()
    }
    
    static func testBenefitsEmptyScreen() throws {
        app.buttons["My Benefits View All"].tap()
        try BenefitsViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try MyProfileViewHelper.testProfileScreenElements()
    }
}
