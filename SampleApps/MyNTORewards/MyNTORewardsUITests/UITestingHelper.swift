//
//  UITestingHelper.swift
//  MyNTORewardsUITests
//
//  Created by Anandhakrishnan Kanagaraj on 05/05/23.
//

import XCTest

final class UITestingHelper: XCTestCase {
    static let app = XCUIApplication()
    static let userName = "archit.sharma@salesforce.com"
    static let password = "test@321"
    static let userNameWithoutPromotion   = ""
    static let passwordWithoutPromotion = ""
    
    static func isLoggedIn() -> Bool {
        return !app.buttons["login_button"].exists
    }
}
