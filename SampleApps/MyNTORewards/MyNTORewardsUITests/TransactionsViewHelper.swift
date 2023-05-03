//
//  TransactionsViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 24/04/23.
//

import XCTest

final class TransactionsViewHelper {
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["My Transactions"].exists)
        XCTAssertTrue(app.staticTexts["Recent"].exists)
        XCTAssertTrue(app.staticTexts["No recent transactions"].exists)
        XCTAssertTrue(app.staticTexts["One month ago"].exists)
        XCTAssertTrue(app.staticTexts["Nothing to report"].exists)
        XCTAssertTrue(app.staticTexts["When you complete your first transaction, you’ll find it here."].exists)
    }
}
