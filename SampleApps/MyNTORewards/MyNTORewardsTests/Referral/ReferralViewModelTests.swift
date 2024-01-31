//
//  ReferralViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Damodaram Nandi on 29/01/24.
//

import XCTest
@testable import MyNTORewards
@testable import ReferralMobileSDK

final class ReferralViewModelTests: XCTestCase {
    var viewModel: ReferralViewModel!
    var forceClient: ForceClient!
    
    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance)
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func test_loadReferralCode() async throws {
        await viewModel.loadReferralCode(membershipNumber: "")
        XCTAssertEqual(viewModel.referralCode, "NOTFOUND-TESTRM")
    }
    
    @MainActor func test_loadAllReferrals() async throws {
        do {
            try await viewModel.loadAllReferrals(memberContactId: "", devMode: true)
            XCTAssertEqual(viewModel.promotionStageCounts[.accepted], 1)
            XCTAssertEqual(viewModel.promotionStageCounts[.sent], 36)
        }
        catch {
            XCTAssert(true)
        }
    }
    
    @MainActor func test_loadAllReferralsWithReload() async throws {
        do {
            try await viewModel.loadAllReferrals(memberContactId: "", reload: true)
            XCTAssertEqual(viewModel.promotionStageCounts[.accepted], 1)
            XCTAssertEqual(viewModel.promotionStageCounts[.sent], 36)
        }
        catch {
            XCTAssert(true)
        }
    }
    
    @MainActor func test_sendReferral() async throws {
        await viewModel.sendReferral(email: "email@test.com")
    }
    
    @MainActor func test_sendReferralError() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        ReferralMockNetworkManager.sharedMock.statusCode = 400
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance)
        await viewModel.sendReferral(email: "email@test.com")
        ReferralMockNetworkManager.sharedMock.statusCode = 200
    }
    
    @MainActor func test_enrollWithMembershipNumberError() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        ReferralMockNetworkManager.sharedMock.statusCode = 400
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance)
        await viewModel.enroll(membershipNumber: "")
        XCTAssertEqual(viewModel.referralCode, "ZGXEW9OZ-Test1009")
        ReferralMockNetworkManager.sharedMock.statusCode = 200

    }
    
    
    @MainActor func test_checkEnrollmentStatus() async throws {
        await viewModel.checkEnrollmentStatus(membershipNumber: "")
    }
    
    @MainActor func test_getMembershipNumber() async throws {
        await viewModel.getMembershipNumber(contactId: "")
        XCTAssertEqual(viewModel.referralMembershipNumber, "MIKETYSON")
    }
    
    @MainActor func test_enrollWithMembershipNumber() async throws {
        await viewModel.enroll(membershipNumber: "")
        XCTAssertEqual(viewModel.referralCode, "ZGXEW9OZ-Test1009")
    }
    
    @MainActor func test_enrollWithContactId() async throws {
        await viewModel.enroll(contactId: "")
        XCTAssertEqual(viewModel.referralCode, "ZGXEW9OZ-Test1009")
    }
}
