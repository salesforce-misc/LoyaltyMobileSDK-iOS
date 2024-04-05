//
//  BadgeViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 29/03/24.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class BadgeViewModelTests: XCTestCase {

	var viewModel: BadgesViewModel!
	
	@MainActor override func setUp() {
		super.setUp()
		let mockAuthenticator = MockAuthenticator.sharedMock
		let currentDate = "2024-03-31".toDate(withFormat: "yyyy-MM-dd") ?? Date()
		viewModel = BadgesViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance, currentDate: currentDate)
	}
	
	override func tearDown() {
		viewModel = nil
		MockFileManager.mockInstance.clear()
		super.tearDown()
	}
	
	/// fetchAllBadges method should load 2 badges in achieved, 1 in available and 1 in expired arrays
	@MainActor
	func testFetchAllBadges_shouldBadgesAccordingly() async throws {
		try await viewModel.fetchAllBadges(membershipNumber: "Testmember03", reload: true, devMode: true)
		
		XCTAssertEqual(viewModel.loyaltyProgramBadges.count, 6)
		XCTAssertEqual(viewModel.loyaltyProgramMemberBadges.count, 4)
		XCTAssertEqual(viewModel.achievedBadges.count, 3)
		XCTAssertEqual(viewModel.availableBadges.count, 1)
		XCTAssertEqual(viewModel.expiredBadges.count, 1)
		XCTAssertEqual(viewModel.previewBadges.count, 3)
		
		XCTAssertEqual(viewModel.achievedBadges[0].id, "0w8B0000000KyjlIBC")
		XCTAssertEqual(viewModel.achievedBadges[1].id, "0w8B0000000KyjlIAC")
		XCTAssertEqual(viewModel.availableBadges[0].id, "0w8B0000000KyjmIAC")
		XCTAssertEqual(viewModel.expiredBadges[0].id, "0w81Q0000004CsnQAE")
		XCTAssertEqual(viewModel.previewBadges[0].id, "0w8B0000000KyjlIBC")
		XCTAssertEqual(viewModel.previewBadges[1].id, "0w8B0000000KyjlIAC")
	}
	
	@MainActor
	func testExpiredDays_shouldBe1_whenExpiredPreviousDay() async throws {
		try await viewModel.fetchAllBadges(membershipNumber: "Testmember03", devMode: true)
		XCTAssertEqual(viewModel.expiredBadges[0].daysToExpire, -1)
	}
	
	@MainActor
	func testFetchAllBadges_shouldSaveBadgesInCache() async throws {
		try await viewModel.fetchAllBadges(membershipNumber: "Testmember03", devMode: true)
		
		let memberBadges = MockFileManager.mockInstance.getData(type: [LoyaltyProgramMemberBadge].self, id: "Testmember03", folderName: "LoyaltyProgramMemberBadges") ?? []
		XCTAssertEqual(memberBadges.count, 4)
	}

	@MainActor
	func testFetchAllBadges_shouldLoadFromCache() async throws {
		let membershipNumber = "testmember01"
		try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, devMode: true)
		
		// Tests if the data is saved in cache.
		let memberBadges = MockFileManager.mockInstance.getData(type: [LoyaltyProgramMemberBadge].self, id: membershipNumber, folderName: "LoyaltyProgramMemberBadges") ?? []
		XCTAssertEqual(memberBadges.count, 4)
		let programBadges = MockFileManager.mockInstance.getData(type: [LoyaltyProgramBadge].self, id: membershipNumber, folderName: "LoyaltyProgramBadges") ?? []
		XCTAssertEqual(programBadges.count, 6)
		
		
		// If loyaltyProgramBadges array is not empty, method skips and neither fetch from API nor from cache. So clearing it.
		viewModel.loyaltyProgramBadges.removeAll()
		// Tests if method fetches data from cache instead of from API since data must be present in cache because of previous API call.
		try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, devMode: true, mockMemberBadgeFileName: "LoyaltyProgramMemberBadgesWithTwoObjects")
		XCTAssertEqual(viewModel.loyaltyProgramMemberBadges.count, 4)
		
		// If loyaltyProgramMemberBadges array is not empty, method skips and neither fetch from API nor from cache. So clearing it.
		viewModel.loyaltyProgramMemberBadges.removeAll()
		// Tests if method fetches data from cache instead of from API since data must be present in cache because of previous API call.
		try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, devMode: true, mockMemberBadgeFileName: "LoyaltyProgramMemberBadgesWithTwoObjects")
		XCTAssertEqual(viewModel.loyaltyProgramMemberBadges.count, 4)
		
		// Tests if reloading fetches data from API.
		try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, reload: true, devMode: true, mockMemberBadgeFileName: "LoyaltyProgramMemberBadgesWithTwoObjects")
		XCTAssertEqual(viewModel.loyaltyProgramMemberBadges.count, 2)
	}
	
	@MainActor
	func testFetchAllBatches_shouldClearCacheAndArrays_whenErrorOccurred() async throws {
		let membershipNumber = "testmember01"
		
		do {
			try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, devMode: true, mockMemberBadgeFileName: "LoyaltyProgramMemberBadgesMissingId")
			XCTFail("Error is expected but not thrown.")
		} catch {
			var expectedError = false
			if let error = error as? CommonError,
			   case .requestFailed = error {
				expectedError = true
			}
			XCTAssertTrue(expectedError)
		}
		
		let memberBadges = MockFileManager.mockInstance.getData(type: [LoyaltyProgramMemberBadge].self, id: membershipNumber, folderName: "LoyaltyProgramMemberBadges") ?? []
		XCTAssertEqual(memberBadges.count, 0)
		
		do {
			try await viewModel.fetchAllBadges(membershipNumber: membershipNumber, devMode: true, mockProgramBadgeFileName: "LoyaltyProgramBadgesMissingId")
			XCTFail("Error is expected but not thrown.")
		} catch {
			var expectedError = false
			if let error = error as? CommonError,
			   case .requestFailed = error {
				expectedError = true
			}
			XCTAssertTrue(expectedError)
		}
		
		let programBadges = MockFileManager.mockInstance.getData(type: [LoyaltyProgramBadge].self, id: membershipNumber, folderName: "LoyaltyProgramBadges") ?? []
		XCTAssertEqual(programBadges.count, 0)
		
		XCTAssertTrue(viewModel.achievedBadges.isEmpty)
		XCTAssertTrue(viewModel.availableBadges.isEmpty)
		XCTAssertTrue(viewModel.expiredBadges.isEmpty)
		XCTAssertTrue(viewModel.previewBadges.isEmpty)
	}
}
