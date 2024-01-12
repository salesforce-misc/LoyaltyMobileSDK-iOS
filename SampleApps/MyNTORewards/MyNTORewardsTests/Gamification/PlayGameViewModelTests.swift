//
//  PlayGameViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 18/12/23.
//

import XCTest
import SwiftUI
@testable import MyNTORewards
@testable import GamificationMobileSDK

final class PlayGameViewModelTests: XCTestCase {

	var viewModel: PlayGameViewModel!
	
	@MainActor override func setUp() {
		super.setUp()
		viewModel = PlayGameViewModel(authManager: GamificationMockAuthenticator.sharedMock, devMode: true)
	}
	
	override func tearDown() {
		viewModel = nil
		super.tearDown()
	}
	
	@MainActor func test_playGame_shouldUpdatePlayedGameRewards() async {
		await viewModel.playGame(gameParticipantRewardId: "ABCD0001")
		XCTAssertEqual(viewModel.playedGameRewards?.count, 2)
	}
	
	@MainActor func test_clear_shouldClearPlayedGameRewards() async {
		await viewModel.playGame(gameParticipantRewardId: "ABCD0001")
		XCTAssertNotNil(viewModel.playedGameRewards)
		viewModel.clear()
		XCTAssertNil(viewModel.playedGameRewards)
	}

	@MainActor func test_playGame_shouldSetFailedStatus() async {
		viewModel = PlayGameViewModel(authManager: GamificationMockAuthenticator.sharedMock,
									  devMode: true,
									  mockFileName: "PlayGame_Fail")
		await viewModel.playGame(gameParticipantRewardId: "ABCD0001")
		XCTAssertNil(viewModel.playedGameRewards)
	}
	
	private final func getGameModel(withColor color: String? = nil) -> GameDefinition {
		GameDefinition(name: "Bonnie and Clyde Style Promotion",
					   gameDefinitionId: "1",
					   description: "Play Spin The Wheel to Get Amazing Rewards",
					   type: GameType.spinaWheel,
					   startDate: "2023-10-01T19:00:00.000Z".toDate() ?? Date(),
					   endDate: "2023-11-23T19:00:00.000Z".toDate() ?? Date(),
					   timeoutDuration: 20,
					   gameRewards: [GameReward(name: "10 % Off",
												color: color,
												rewardType: .voucher,
												rewardValue: nil,
												imageUrl: nil,
												description: "Win \n **20% \n Off**",
												gameRewardId: "502")
					   ],
					   participantGameRewards: [ParticipantGameReward(gameParticipantRewardID: "201",
																	  status: .yetToReward,
																	  issuedRewardReference: "12344",
																	  gameRewardId: "501",
																	  sourceActivity: "201",
																	  expirationDate: "2023-12-23T19:00:00.000Z".toDate())
					   ])
	}
	
	@MainActor func test_getWheelColors_shouldReturnNilWhenPassedNil() {
		let colors = viewModel.getWheelColors(gameModel: nil)
		XCTAssertNil(colors)
	}
	
	@MainActor func test_getWheelColors_shouldReturnColorObjectWhenHexPassed() {
		let gameDefinition = getGameModel(withColor: "01CD6C")
		let wheelColors = viewModel.getWheelColors(gameModel: gameDefinition)
		XCTAssertTrue(wheelColors?.first is Color)
		XCTAssertEqual(wheelColors?.first?.description, "#01CD6CFF")
	}
	
	@MainActor func test_getWheelColors_shouldReturnColors() {
		let playGameViewModel = PlayGameViewModel(authManager: GamificationMockAuthenticator.sharedMock, 
												  devMode: true,
												  mockFileName: "PlayGame_Success")
		let gameDefinition = getGameModel()
		let wheelColorsArray = playGameViewModel.getWheelColors(gameModel: gameDefinition)
		XCTAssertTrue(wheelColorsArray?.first is Color)
		XCTAssertEqual(wheelColorsArray?.first?.description, "white")
	}
	
	@MainActor func test_getWheelColors_shouldReturnWhiteWhenGameHasNoColor() {
		let gameDefinitionWithoutColor = getGameModel(withColor: nil)
		let wheelColors = viewModel.getWheelColors(gameModel: gameDefinitionWithoutColor)
		XCTAssertTrue(wheelColors?.first is Color)
		XCTAssertEqual(wheelColors?.first, .white)
	}
}
