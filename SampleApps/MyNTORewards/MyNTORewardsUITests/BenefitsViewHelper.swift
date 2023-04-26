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
}
