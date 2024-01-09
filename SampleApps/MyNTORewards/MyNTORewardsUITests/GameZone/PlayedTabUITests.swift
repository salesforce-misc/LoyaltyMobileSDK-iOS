//
//  PlayedTabUITests.swift
//  MyNTORewardsUITests
//
//  Created by Vasanthkumar Velusamy on 02/01/24.
//

import XCTest

final class PlayedTabUITests: XCTestCase {

	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		XCUIDevice.shared.orientation = .portrait
		app.launchArguments = ["ui_test"]
		app.launchEnvironment = ["get_games": "success"]
		app.launch()
		GameZoneViewHelper.goToGameZoneView(app: app)
		app.staticTexts["Played"].tap()
	}
	
	func test_playedGamesTabUIElements() {
		let grid = app.otherElements["game_grid"]
		XCTAssertTrue(grid.waitForExistence(timeout: 5), "Game lazy grid should be visible")
		
		let playedGames = grid.staticTexts.containing(NSPredicate(format: "identifier CONTAINS 'game_zone_played_card_title'"))
		XCTAssertEqual(playedGames.count, 2, "There should be 2 games on the screen")
	}
	
	func test_tappingRewardWonGame_shouldShowCongratsSheet() {
		let grid = app.otherElements["game_grid"]
		let playedGames = grid.staticTexts.containing(NSPredicate(format: "identifier CONTAINS 'game_zone_played_card_title'"))
		playedGames.element(boundBy: 0).tap()
		let congratsTitle = app.staticTexts["Congratulations!"]
		let congratsSubtitle = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Here’s your reward: 10% Off Voucher'")).firstMatch
		XCTAssertTrue(congratsTitle.waitForExistence(timeout: 2))
		XCTAssertTrue(congratsSubtitle.exists)
	}
	
	func test_tappingNoRewardWonGame_shouldShowBetterLuckSheet() {
		let grid = app.otherElements["game_grid"]
		let playedGames = grid.staticTexts.containing(NSPredicate(format: "identifier CONTAINS 'game_zone_played_card_title'"))
		playedGames.element(boundBy: 1).tap()
		let betterLuckTitle = app.staticTexts["Better luck next time!"]
		let betterLuckSubtitle = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Thank you for playing'")).firstMatch
		XCTAssertTrue(betterLuckTitle.waitForExistence(timeout: 2))
		XCTAssertTrue(betterLuckSubtitle.exists)
	}
}
