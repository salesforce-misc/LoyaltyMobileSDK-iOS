//
//  BadgesViewHelper.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 31/03/24.
//

import XCTest

final class BadgesViewHelper: XCTestCase {

	static func goToMyBadgesView(app: XCUIApplication) {
		app.tabBars.buttons["My Profile"].tap()
		let viewAllBadgesButton = app.buttons.containing(NSPredicate(format: "identifier CONTAINS 'My Badges View All'"))
		XCTAssertTrue(viewAllBadgesButton.firstMatch.waitForExistence(timeout: 3))
		app.swipeUp(velocity: .fast)
		app.swipeUp(velocity: .fast)
		viewAllBadgesButton.firstMatch.tap()
	}
	
	static func pullToRefresh(app: XCUIApplication) {
		let firstCell = app.staticTexts["Available"]
		let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 20))
		let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 40))
		start.press(forDuration: 0, thenDragTo: finish)
	}
}
