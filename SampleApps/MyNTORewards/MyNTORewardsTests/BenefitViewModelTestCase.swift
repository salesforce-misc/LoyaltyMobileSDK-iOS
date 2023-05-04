//
//  BenefitViewModelTestCase.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 10/04/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class BenefitViewModelTestCase: XCTestCase {

    var viewModel: BenefitViewModel!

    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = BenefitViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func testFetchBenefits() async throws {
        try await viewModel.fetchBenefits(memberId: "MIR002", devMode: true)
        XCTAssertEqual(viewModel.benefits.count, 6)
        XCTAssertEqual(viewModel.benefits[0].id, "0ji4x0000008REdAAM")
        XCTAssertEqual(viewModel.benefits[1].id, "0ji4x0000008REjAAM")
        XCTAssertEqual(viewModel.benefits[2].id, "0ji4x0000008REeAAM")
        XCTAssertEqual(viewModel.benefits[3].id, "0ji4x0000008REZAA2")
        XCTAssertEqual(viewModel.benefits[4].id, "0ji4x0000008REiAAM")
        XCTAssertEqual(viewModel.benefits[5].id, "0ji4x0000008REfAAM")
    }

    @MainActor func testGetBenefits() async throws {
        try await viewModel.getBenefits(memberId: "MIR002", reload: false, devMode: true)
        XCTAssertEqual(viewModel.benefits.count, 6)
        XCTAssertEqual(viewModel.benefits[0].id, "0ji4x0000008REdAAM")
        XCTAssertEqual(viewModel.benefits[1].id, "0ji4x0000008REjAAM")
        XCTAssertEqual(viewModel.benefits[2].id, "0ji4x0000008REeAAM")
        XCTAssertEqual(viewModel.benefits[3].id, "0ji4x0000008REZAA2")
        XCTAssertEqual(viewModel.benefits[4].id, "0ji4x0000008REiAAM")
        XCTAssertEqual(viewModel.benefits[5].id, "0ji4x0000008REfAAM")
        
        /// Clear the data from cache
        viewModel.clear()
        MockFileManager.mockInstance.clear()
        XCTAssertEqual(viewModel.benefits.count, 0)
        
       /// Reload from server
        try await viewModel.getBenefits(memberId: "MIR002", reload: true, devMode: true)
        XCTAssertEqual(viewModel.benefits.count, 6)
    }
}
