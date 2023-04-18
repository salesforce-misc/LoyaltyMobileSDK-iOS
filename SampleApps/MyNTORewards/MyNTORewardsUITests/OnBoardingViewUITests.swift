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
        app.launch()
    }

    /// Flow Verification
    /// 1. Verifying onboarding Elements
    /// 2. Tap Join button and verify signup screen
    /// 3. Tap login button and verify login screen
    /// 4. Tap logout and verify logout
    
    func testOnBoardingFlow() throws {
        // UI tests must launch the application that they test.
        
        try OnBoardingViewHelper.testOnBoardingScreen()
        try SignUpViewHelper.testSignUpPage()
        try SignInViewHelper.testSignInScreen()
        try MoreViewHelper.testMoreScreen()
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
