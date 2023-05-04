//
//  ProfileViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 13/03/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileViewModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = ProfileViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func testFetchProfile() async throws {
        try await viewModel.fetchProfile(memberId: "1234", devMode: true)
        XCTAssertEqual((viewModel.profile?.loyaltyProgramMemberID ?? ""), "0lM4x000000LECAEA4")
        XCTAssertEqual(viewModel.profile?.loyaltyProgramName ?? "", "NTO Insider")
        XCTAssertEqual(viewModel.profile?.membershipNumber ?? "", "Member1")
        XCTAssertEqual(viewModel.profile?.memberStatus ?? "", "Active")
    }
    
    @MainActor func testGetProfileData() async throws {
        /// clear profile and remove local database and reload false scenerio
        viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.getProfileData(memberId: "1234",reload: false, devMode: true)
        XCTAssertEqual((viewModel.profile?.loyaltyProgramMemberID ?? ""), "0lM4x000000LECAEA4")
        XCTAssertEqual(viewModel.profile?.loyaltyProgramName ?? "", "NTO Insider")
        XCTAssertEqual(viewModel.profile?.membershipNumber ?? "", "Member1")
        XCTAssertEqual(viewModel.profile?.memberStatus ?? "", "Active")
        
        /// clear profile and reload true scenerio
        viewModel.clear()
        try await viewModel.getProfileData(memberId: "1234",reload: true, devMode: true)
        XCTAssertEqual((viewModel.profile?.loyaltyProgramMemberID ?? ""), "0lM4x000000LECAEA4")
        
        /// clear profile and reload false scenerio
        try await viewModel.getProfileData(memberId: "1234",reload: false, devMode: true)
        XCTAssertEqual((viewModel.profile?.loyaltyProgramMemberID ?? ""), "0lM4x000000LECAEA4")
    }
}
