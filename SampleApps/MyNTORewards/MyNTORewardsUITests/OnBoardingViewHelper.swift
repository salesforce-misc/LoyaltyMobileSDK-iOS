//
//  OnBoardingViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 18/04/23.
//

import XCTest

final class OnBoardingViewHelper {
    static let app = XCUIApplication()
    
    static func testOnBoardingScreen() throws {
        try testOnboardingElements()
        try testOnboardingSwipe()
    }
    
    static func testOnboardingElements() throws {
        XCTAssertTrue(app.buttons["login_button"].exists)
        XCTAssertTrue(app.buttons["join_button"].exists)
        XCTAssertTrue(app.staticTexts["already_member_label"].exists)
        XCTAssertTrue(app.staticTexts["onboarding_description"].exists)
        XCTAssertTrue(app.images["onboarding_image"].exists)
    }
    
    static func testOnboardingSwipe() throws {
        // verifying the swiping functionality
        XCTAssertTrue(app.staticTexts["Redeem your points for exciting vouchers!"].exists)
        
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Earn points to unlock new rewards!"].exists)
        
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Get personalized offers!"].exists)
        
        XCTAssertTrue(app.images["onboarding_image"].exists)
        
        app.swipeRight()
        app.swipeRight()
        XCTAssertTrue(app.staticTexts["Redeem your points for exciting vouchers!"].exists)
    }
    
}
