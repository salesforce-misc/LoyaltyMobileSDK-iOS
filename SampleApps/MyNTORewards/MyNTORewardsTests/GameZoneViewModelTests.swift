//
//  GameZoneViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 18/12/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class GameZoneViewModelTests: XCTestCase {
	var viewModel: GameZoneViewModel!
	
	@MainActor override func setUp() {
		super.setUp()
		viewModel = GameZoneViewModel(authManager: MockAuthenticator.sharedMock, localFileManager: MockFileManager.mockInstance, devMode: true)
	}
	
	override func tearDown() {
		viewModel = nil
		super.tearDown()
	}
	
	@MainActor func test_getGamesTest() async throws {
		try await viewModel.getGames(participantId: "faKeParticiPaNtId007")
		XCTAssertEqual(viewModel.activeGameDefinitions?.count, 3)
		XCTAssertEqual(viewModel.playedGameDefinitions?.count, 0)
		XCTAssertEqual(viewModel.expiredGameDefinitions?.count, 1)
	}
	
	@MainActor func test_getGamesFailTest() async throws {
		viewModel = GameZoneViewModel(authManager: MockAuthenticator.sharedMock, localFileManager: MockFileManager.mockInstance, devMode: true, mockFileName: "GetGames_Fail")
		do {
			try await viewModel.getGames(participantId: "faKeParticiPaNtId007")
			XCTAssert(false)
		}
		catch {
			XCTAssert(true)
		}
	}
	
	@MainActor func test_reloadAndClear() async throws {
		try await viewModel.reload(id: "faKeParticiPaNtId007", number: "7")
		XCTAssertEqual(viewModel.activeGameDefinitions?.count, 3)
		XCTAssertEqual(viewModel.playedGameDefinitions?.count, 0)
		XCTAssertEqual(viewModel.expiredGameDefinitions?.count, 1)
		viewModel.clear()
		XCTAssertNil(viewModel.activeGameDefinitions)
		XCTAssertNil(viewModel.playedGameDefinitions)
		XCTAssertNil(viewModel.expiredGameDefinitions)
	}
	
}
