//
//  ReferralViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Damodaram Nandi on 29/01/24.
//

import XCTest
@testable import MyNTORewards

final class ReferralViewModelTests: XCTestCase {
    var viewModel: ReferralViewModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = ReferralViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)

    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func test_getGamesTest() async throws {
        try await viewModel.loadReferralCode(membershipNumber: "")
        XCTAssertEqual(viewModel.referralCode, "")

    }
    
}
