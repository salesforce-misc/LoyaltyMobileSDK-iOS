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
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        try OnBoardingViewHelper.testOnBoardingScreen()
        try SignUpViewHelper.testSignUpPage()
        try SignInViewHelper.testSignInScreen()
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification
    /// 1. Tap login button and verify login
    /// 2. Tap Home, My promotions, My profile , More button
    /// 3. Verify all the empty screen without promotions and vouchers
    /// 4. Tap logout and verify logout
    
    func testTabBarButton() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        
        try SignInViewHelper.testLogin()
        app.tabBars.buttons["Home"].tap()
        try HomeViewHelper.testAllElements()
        app.tabBars.buttons["My Promotions"].tap()
        try PromotionViewHelper.testAllElements()
        app.tabBars.buttons["My Profile"].tap()
        try MyProfileViewHelper.testProfileScreenElements()
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification Home
    /// 1. Tap login button and verify login
    /// 2. Tap Home verify all the elements are present
    /// 3. Verify Promotions empty screen
    /// 4. Verify Vouchers empty screen
    /// 5. Tap logout and verify logout
    func testHomeEmptyScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLogin()
        app.tabBars.buttons["Home"].tap()
        if !UITestingHelper.userNameWithoutPromotion .isEmpty {
            try HomeViewHelper.testEmptyViewElements()
            try HomeViewHelper.testPromotionViewElements()
            try HomeViewHelper.testVoucherViewElements()
        }
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification Home
    /// 1. Tap login button and verify login
    /// 2. Tap Home verify all the elements are present
    /// 3. Verify Promotions carousel
    /// 4. Tap logout and verify logout
    func testHomeScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLoginWithPromotions()
        app.tabBars.buttons["Home"].tap()
        try HomeViewHelper.testHomeScreen()
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification My Promotions
    /// 1. Tap login button and verify login
    /// 2. Tap promotions verify all the elements are present
    /// 3. Verify Promotions empty screen
    /// 4. Tap logout and verify logout
    func testPromotionsEmptyScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLogin()
        app.tabBars.buttons["My Promotions"].tap()
        if !UITestingHelper.userNameWithoutPromotion .isEmpty {
            try PromotionViewHelper.testEmptyViewElements()
        }
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification My Promotions
    /// 1. Tap login button and verify login
    /// 2. Tap promotions verify all the elements are present
    /// 3. Verify Promotions on Active, Eligible and All
    /// 4. Tap logout and verify logout
    func testPromotionScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLoginWithPromotions()
        app.tabBars.buttons["My Promotions"].tap()
        try PromotionViewHelper.testPromotionView()
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification
    /// 1. Tap login button and verify login
    /// 2. Tap My profile verify all the elements are present
    /// 3. Verify QR screen
    /// 4. Verify transactions empty screen
    /// 5. Verify Vouchers empty screen
    /// 6. Verify Benefits empty screen
    /// 7. Tap logout and verify logout
    func testProfileEmptyScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLogin()
        app.tabBars.buttons["My Profile"].tap()
        if !UITestingHelper.userNameWithoutPromotion .isEmpty {
            try MyProfileViewHelper.testEmptyViewElements()
            try MyProfileViewHelper.testQRScreen()
            try TransactionsViewHelper.testTransactionsEmptyScreen()
            try VoucherViewHelper.testVoucherEmptyScreen()
            try BenefitsViewHelper.testBenefitsEmptyScreen()
        }
        try MoreViewHelper.testMoreScreen()
    }
    
    /// Flow Verification
    /// 1. Tap login button and verify login
    /// 2. Tap My profile verify all the elements are present
    /// 3. Verify QR screen
    /// 4. Verify transactions screen
    /// 5. Verify Vouchers screen
    /// 6. Verify Benefits screen
    /// 7. Tap logout and verify logout
    func testProfileScreen() throws {
        if UITestingHelper.isLoggedIn() {
            try MoreViewHelper.testMoreScreen()
        }
        let loginButton = app.buttons["login_button"]
        loginButton.tap()
        try SignInViewHelper.testLoginWithPromotions()
        app.tabBars.buttons["My Profile"].tap()
        try MyProfileViewHelper.testProfileScreenElements()
        try MyProfileViewHelper.testQRScreen()
        try TransactionsViewHelper.testTransactionScreen()
        try VoucherViewHelper.testVoucherScreen()
        try BenefitsViewHelper.testBenefitScreen()
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
