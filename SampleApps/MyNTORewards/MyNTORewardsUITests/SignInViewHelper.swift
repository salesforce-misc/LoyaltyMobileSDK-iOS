//
//  SignInViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class SignInViewHelper {
    static let app = XCUIApplication()
    
    static func testSignInScreen() throws {
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        
        try testSignInElements()
        try testLogin()
    }
    
    static func testSignInElements() throws {
        XCTAssertTrue(app.textFields["username_textfield"].exists)
        XCTAssertTrue(app.secureTextFields["password_textfield"].exists)
        
        let buttons = app.buttons
        XCTAssertTrue(buttons["login_button"].exists)
        XCTAssertTrue(buttons["join_now_button"].exists)
        
        XCTAssertTrue(app.staticTexts["forgot_password"].exists)
        XCTAssertTrue(app.staticTexts["login_header"].exists)
        XCTAssertTrue(app.staticTexts["not_a_member_text"].exists)
    }
    
    static func testLogin() throws {
        app.buttons["signIn_login_button"].tap()
        app.textFields["username_textfield"].tap()
        app.textFields["username_textfield"].typeText("test128@test.com")
        
        app.secureTextFields["password_textfield"].tap()
        app.secureTextFields["password_textfield"].typeText("Abcd1234")
        
        app.buttons["signIn_login_button"].tap()
        
        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.tabBars.buttons["My Promotions"].exists)
        XCTAssertTrue(app.tabBars.buttons["My Profile"].exists)
        XCTAssertTrue(app.tabBars.buttons["More"].exists)
    }
    
}
