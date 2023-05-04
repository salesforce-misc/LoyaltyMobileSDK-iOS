//
//  SignUpViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        typeText(deleteString)
    }
}

final class SignUpViewHelper {
    static let app = XCUIApplication()
    
    static func testSignUpPage() throws {
        // verifying the signup button event
        let signUpButton = app.buttons["join_button"]
        signUpButton.tap()
        
        try testSignUpElements()
        try testWithWrongInput()
        try testSignUpTextField()
        try testDismissButton()
    }
    
    static func testSignUpElements() throws {
        /// verifying the textfield
        let textFields = app.textFields
        XCTAssertTrue(textFields["first_name_textfield"].exists)
        XCTAssertTrue(textFields["last_name_textfield"].exists)
        XCTAssertTrue(textFields["email_textfield"].exists)
        XCTAssertTrue(textFields["phone_textfield"].exists)
        
        /// verifying the secureTextFields
        let secureTextFields = app.secureTextFields
        XCTAssertTrue(secureTextFields["password_textfield"].exists)
        XCTAssertTrue(secureTextFields["confirm_textfield"].exists)
        
        /// verifying the checkbox
        XCTAssertTrue(app.switches["agree_checkbox"].exists)
        XCTAssertTrue(app.switches["maillist_checkbox"].exists)
    }
    
    static func testWithWrongInput() throws {
        let textFields = app.textFields
        let secureTextFields = app.secureTextFields
        
        let firstName = textFields["first_name_textfield"]
        let lastName = textFields["last_name_textfield"]
        let email = textFields["email_textfield"]
        let phone = textFields["phone_textfield"]
        
        let password = secureTextFields["password_textfield"]
        let confirmPassword = secureTextFields["confirm_textfield"]
        
        firstName.tap()
        firstName.typeText("1234")
        
        lastName.tap()
        lastName.typeText("1234")
        
        email.tap()
        email.typeText("email")
        
        phone.tap()
        phone.typeText("phone")
        
        password.tap()
        password.typeText("321")
        
        confirmPassword.tap()
        confirmPassword.typeText("321")
        
        XCTAssertTrue(app.staticTexts["first_name_textfield_error"].exists)
        XCTAssertTrue(app.staticTexts["last_name_textfield_error"].exists)
        XCTAssertTrue(app.staticTexts["email_textfield_error"].exists)
        XCTAssertTrue(app.staticTexts["phone_textfield_error"].exists)
        firstName.tap()
    }
    
    static func testSignUpTextField() throws {
        let textFields = app.textFields
        let secureTextFields = app.secureTextFields
        
        let firstName = textFields["first_name_textfield"]
        let lastName = textFields["last_name_textfield"]
        let email = textFields["email_textfield"]
        let phone = textFields["phone_textfield"]
        
        let password = secureTextFields["password_textfield"]
        let confirmPassword = secureTextFields["confirm_textfield"]
        
        let mailSwitch = app.switches["maillist_checkbox"]
        
        firstName.tap()
        firstName.clearText()
        firstName.typeText("testFirstName")
        
        lastName.tap()
        lastName.clearText()
        lastName.typeText("lastName")
        
        email.tap()
        email.clearText()
        email.typeText("email@email.com")
        
        phone.tap()
        phone.clearText()
        phone.typeText("9876543210")
        
        password.tap()
        password.clearText()
        password.typeText("password1234")
        
        confirmPassword.tap()
        confirmPassword.clearText()
        confirmPassword.typeText("password1234")
        
        let accceptButton = app.buttons["agree_button"]
        accceptButton.tap()
        
        XCTAssertTrue(app.staticTexts["Terms and Conditions"].exists)
        
        app.buttons["Terms and Conditions_dismiss"].tap()
        
        // agreeSwitch.tap()
        mailSwitch.tap()
    
        XCTAssertFalse(app.staticTexts["first_name_textfield_error"].exists)
        XCTAssertFalse(app.staticTexts["last_name_textfield_error"].exists)
        XCTAssertFalse(app.staticTexts["email_textfield_error"].exists)
        XCTAssertFalse(app.staticTexts["phone_textfield_error"].exists)
    }
    
    static func testDismissButton() throws {
        let dismissButton = app.buttons["Join_dismiss"]
        dismissButton.tap()
        
        XCTAssertTrue(app.buttons["login_button"].exists)
        XCTAssertTrue(app.buttons["join_button"].exists)
    }
}
