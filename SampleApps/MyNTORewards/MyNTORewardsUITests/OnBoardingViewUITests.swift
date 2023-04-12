//
//  OnBoardingViewUITests.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 11/04/23.
//

import XCTest

final class OnBoardingViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAllUIElements() throws {
        // UI tests must launch the application that they test.
        app.launch()
        
        XCTAssertTrue(app.buttons["login_button"].exists)
        XCTAssertTrue(app.buttons["join_button"].exists)
        XCTAssertTrue(app.staticTexts["already_member_label"].exists)
        XCTAssertTrue(app.staticTexts["onboarding_description"].exists)
        XCTAssertTrue(app.images["onboarding_image"].exists)
    }
    
    func testSwipe() throws {
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Redeem your points for exciting vouchers!"].exists)
        
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Earn points to unlock new rewards!"].exists)
        
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Get personalized offers!"].exists)
        
        XCTAssertTrue(app.images["onboarding_image"].exists)
    }
    
    func testSignupButtonTap() throws {
        app.launch()
        
        let signUpButton = app.buttons["join_button"]
        signUpButton.tap()
        
        XCTAssertTrue(app.staticTexts["join_Label"].exists)
    }
    
    func testLoginButtonTap() throws {
        app.launch()
        
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        
        XCTAssertTrue(app.staticTexts["login_header"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
