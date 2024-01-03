//
//  PromotionViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 13/03/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class PromotionViewModelTests: XCTestCase {

    var viewModel: PromotionViewModel!

    override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = PromotionViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchCarouselPromotions() async throws {
        try await viewModel.fetchCarouselPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.promotions.count == 5)
        XCTAssertEqual(viewModel.promotions[0].id, "0c84x000000CoNiAAK")
        XCTAssertEqual(viewModel.promotions[1].id, "0c84x000000CtzRAAS")
        XCTAssertEqual(viewModel.promotions[2].id, "0c84x000020CtzWAAS")
        XCTAssertEqual(viewModel.promotions[3].id, "0c84x004000CoNhAAK")
		XCTAssertEqual(viewModel.promotions[4].id, "0c84x000006CoNiAAK")
    }
    
    func testLoadCarouselPromotions() async throws {
        try await viewModel.loadCarouselPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.promotions.count == 5)
		XCTAssertEqual(viewModel.promotions[0].id, "0c84x000000CoNiAAK")
		XCTAssertEqual(viewModel.promotions[1].id, "0c84x000000CtzRAAS")
		XCTAssertEqual(viewModel.promotions[2].id, "0c84x000020CtzWAAS")
		XCTAssertEqual(viewModel.promotions[3].id, "0c84x004000CoNhAAK")
		XCTAssertEqual(viewModel.promotions[4].id, "0c84x000006CoNiAAK")
    }
    
    func testLoadAllPromotions() async throws {
        await viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadAllPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.allEligiblePromotions.count == 7)
        
        await viewModel.clear()
        try await viewModel.loadAllPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.allEligiblePromotions.count == 7)
		XCTAssertEqual(viewModel.allEligiblePromotions[0].id, "0c84x000000CoNiAAK")
		XCTAssertEqual(viewModel.allEligiblePromotions[1].id, "0c84x000000CtzRAAS")
		XCTAssertEqual(viewModel.allEligiblePromotions[2].id, "0c84x000020CtzWAAS")
		XCTAssertEqual(viewModel.allEligiblePromotions[3].id, "0c84x004000CoNhAAK")
		XCTAssertEqual(viewModel.allEligiblePromotions[4].id, "0c84x000006CoNiAAK")
        XCTAssertEqual(viewModel.allEligiblePromotions[5].id, "0c84x070000CtzRAAS")
        XCTAssertEqual(viewModel.allEligiblePromotions[6].id, "0c84x000000CtzWAAS")
    }
    
    func testFetchAllPromotions() async throws {
        try await viewModel.fetchAllPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertFalse(viewModel.allEligiblePromotions.isEmpty)
        XCTAssertTrue(viewModel.allEligiblePromotions.count == 7)
		XCTAssertEqual(viewModel.allEligiblePromotions[0].id, "0c84x000000CoNiAAK")
		XCTAssertEqual(viewModel.allEligiblePromotions[1].id, "0c84x000000CtzRAAS")
		XCTAssertEqual(viewModel.allEligiblePromotions[2].id, "0c84x000020CtzWAAS")
		XCTAssertEqual(viewModel.allEligiblePromotions[3].id, "0c84x004000CoNhAAK")
		XCTAssertEqual(viewModel.allEligiblePromotions[4].id, "0c84x000006CoNiAAK")
		XCTAssertEqual(viewModel.allEligiblePromotions[5].id, "0c84x070000CtzRAAS")
		XCTAssertEqual(viewModel.allEligiblePromotions[6].id, "0c84x000000CtzWAAS")
    }
    
    func testFetchActivePromotions() async throws {
        try await viewModel.fetchActivePromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.activePromotions.count == 4)
        XCTAssertEqual(viewModel.activePromotions[0].id, "0c84x000000CoNiAAK")
        XCTAssertEqual(viewModel.activePromotions[1].id, "0c84x000020CtzWAAS")
        XCTAssertEqual(viewModel.activePromotions[2].id, "0c84x004000CoNhAAK")
        XCTAssertEqual(viewModel.activePromotions[3].id, "0c84x000006CoNiAAK")
//        XCTAssertEqual(viewModel.activePromotions[4].id, "0c84x000006CoNiAAK")
    }
    
    func testLoadActivePromotions() async throws {
        await viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadActivePromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.activePromotions.count == 4)
        
        await viewModel.clear()
        try await viewModel.loadActivePromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.activePromotions.count == 4)
        XCTAssertEqual(viewModel.activePromotions[0].id, "0c84x000000CoNiAAK")
        XCTAssertEqual(viewModel.activePromotions[1].id, "0c84x000020CtzWAAS")
        XCTAssertEqual(viewModel.activePromotions[2].id, "0c84x004000CoNhAAK")
        XCTAssertEqual(viewModel.activePromotions[3].id, "0c84x000006CoNiAAK")
    }
    
    func testFetchUnenrolledPromotions() async throws {
        try await viewModel.fetchUnenrolledPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.unenrolledPromotions.count == 2)
        XCTAssertEqual(viewModel.unenrolledPromotions[0].id, "0c84x000000CtzRAAS")
        XCTAssertEqual(viewModel.unenrolledPromotions[1].id, "0c84x070000CtzRAAS")
    }
    
    func testLoadUnenrolledPromotions() async throws {
        await viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadUnenrolledPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.unenrolledPromotions.count == 2)
        
        await viewModel.clear()
        try await viewModel.loadUnenrolledPromotions(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.unenrolledPromotions.count == 2)
        XCTAssertEqual(viewModel.unenrolledPromotions[0].id, "0c84x000000CtzRAAS")
        XCTAssertEqual(viewModel.unenrolledPromotions[1].id, "0c84x070000CtzRAAS")
    }
    
    func testUpdatePromotions() async {
        await viewModel.updatePromotionsFromCache(membershipNumber: "1234", promotionId: "1234")
        XCTAssertFalse(viewModel.activePromotions.isEmpty)
    }
}
