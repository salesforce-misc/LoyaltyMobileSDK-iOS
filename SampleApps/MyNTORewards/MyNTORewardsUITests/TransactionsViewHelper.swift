//
//  TransactionsViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 24/04/23.
//

import XCTest

final class TransactionsViewHelper{
    static let app = XCUIApplication()
    
    static func testEmptyViewElements() throws {
        XCTAssertTrue(app.staticTexts["My Transactions"].exists)
        XCTAssertTrue(app.staticTexts["Recent"].exists)
        XCTAssertTrue(app.staticTexts["No recent transactions"].exists)
        XCTAssertTrue(app.staticTexts["One month ago"].exists)
        XCTAssertTrue(app.staticTexts["Nothing to report"].exists)
        XCTAssertTrue(app.staticTexts["When you complete your first transaction, you’ll find it here."].exists)
    }
    
    static func testTransactionCardView() throws {
        for i in 0..<5 {
            guard app.images["transaction_\(i)_logo"].waitForExistence(timeout: 2) else {
                return
            }
            XCTAssertTrue(app.staticTexts["transaction_\(i)_name"].exists)
            XCTAssertTrue(app.staticTexts["transaction_\(i)_date"].exists)
            XCTAssertTrue(app.staticTexts["transaction_\(i)_points"].exists)
        }
    }
    
    static func testTransactionScreen() throws {
        app.buttons["My Transactions View All"].tap()
        XCTAssertTrue(app.staticTexts["My Transactions"].exists)
        XCTAssertTrue(app.buttons["back_button"].exists)
        try testTransactionCardView()
        app.buttons["back_button"].tap()
    }
    
    static func testTransactionsEmptyScreen() throws {
        app.buttons["My Transactions View All"].tap()
        try TransactionsViewHelper.testEmptyViewElements()
        app.buttons["back_button"].tap()
        try MyProfileViewHelper.testProfileScreenElements()
    }
}
