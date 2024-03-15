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
        viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance, devMode: true, isEnrolledMock: true)
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func test_loadReferralCode() async throws {
        await viewModel.loadReferralCode(membershipNumber: "", promoCode:AppSettings.Defaults.promotionCode)
        XCTAssertEqual(viewModel.referralCode, "NOTFOUND")
    }
    
    @MainActor func test_isEnrolledForDefaultPromotion() async throws {
        await viewModel.isEnrolledForDefaultPromotion(contactId: "")
        XCTAssertEqual(viewModel.promotionScreenType, .referFriend)
    }
    
    @MainActor func test_getReferralsDataFromServer() async throws {
        try await viewModel.getReferralsDataFromServer(memberContactId: "")
        XCTAssertEqual(viewModel.promotionStageCounts[.accepted], 1)
        XCTAssertEqual(viewModel.promotionStageCounts[.sent], 36)

    }
    
    @MainActor func test_loadAllReferrals() async throws {
        do {
            try await viewModel.loadAllReferrals(memberContactId: "")
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
        try await viewModel.sendReferral(email: "email@test.com", promoCode: AppSettings.Defaults.promotionCode)
    }
    
    @MainActor func test_sendReferralError() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        ReferralMockNetworkManager.sharedMock.statusCode = 400
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance)
        try await viewModel.sendReferral(email: "email@test.com", promoCode: AppSettings.Defaults.promotionCode)
        ReferralMockNetworkManager.sharedMock.statusCode = 200
    }
    
    @MainActor func test_enrollWithMembershipNumberError() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        ReferralMockNetworkManager.sharedMock.statusCode = 400
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance)
        await viewModel.enroll(contactId: "")
        XCTAssertEqual(viewModel.referralCode, "")
        ReferralMockNetworkManager.sharedMock.statusCode = 200
    }
    
    @MainActor func test_loadAllReferallsWithOutDevMode() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance,devMode: false)
        try await viewModel.loadAllReferrals(memberContactId: "")
        XCTAssertEqual(viewModel.promotionStageCounts[.accepted], 1)
        XCTAssertEqual(viewModel.promotionStageCounts[.sent], 36)   
    }
    
    @MainActor func test_loadAllReferralsWithOutCache() async throws {
        MockFileManager.mockInstance.clear()
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        let viewModel = ReferralViewModel(authManager: mockAuthenticator, forceClient: forceClient, localFileManager: MockFileManager.mockInstance, devMode: false)
        do {
            
            try await viewModel.loadAllReferrals(memberContactId: "")
            XCTAssertEqual(viewModel.promotionStageCounts[.accepted], 1)
            XCTAssertEqual(viewModel.promotionStageCounts[.sent], 36)
        } catch {
            XCTAssert(true)
        }
    }
    
    @MainActor func test_enrollWithContactId() async throws {
        await viewModel.enroll(contactId: "")
        XCTAssertEqual(viewModel.referralCode, "ZGXEW9OZ")
    }
    
    @MainActor func test_getDefaultPromotionData() async throws {
        try await viewModel.getDefaultPromotionDetailsAndEnrollmentStatus(contactId: "")
        XCTAssertNotNil(viewModel.defaultPromotionInfo)
        XCTAssertEqual(viewModel.defaultPromotionInfo?.name, "Referral Promotion Without  Description")
    }
}
