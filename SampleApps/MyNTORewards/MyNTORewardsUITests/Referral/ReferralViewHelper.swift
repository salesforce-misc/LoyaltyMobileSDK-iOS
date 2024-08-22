//
//  ReferralViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/01/24.
//

import XCTest

final class ReferralViewHelper: XCTestCase {
	
	static func goToReferralView(app: XCUIApplication) {
		app.tabBars.buttons["More"].tap()
		app.buttons["My Referrals"].tap()
	}
	
	static func goToReferAFriendView(app: XCUIApplication) {
		goToReferralView(app: app)
		XCTAssertTrue(app.buttons["Refer Now"].waitForExistence(timeout: 5))
		app.buttons["Refer Now"].tap()
	}
}
