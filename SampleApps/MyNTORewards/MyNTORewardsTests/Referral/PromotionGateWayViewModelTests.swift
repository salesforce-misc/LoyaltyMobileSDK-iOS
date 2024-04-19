//
//  PromotionGateWayViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Damodaram Nandi on 22/02/24.
//

import XCTest
@testable import MyNTORewards
@testable import ReferralMobileSDK

final class PromotionGateWayViewModelTests: XCTestCase {

    var viewModel: PromotionGateWayViewModel!
    var forceClient: ForceClient!
    
    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        viewModel = PromotionGateWayViewModel(authManager: mockAuthenticator, forceClient: forceClient)
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor func test_enrollWithContactIdError() async throws {
        let mockAuthenticator = MockAuthenticator.sharedMock
        let forceClient = ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: ReferralMockNetworkManager.sharedMock)
        ReferralMockNetworkManager.sharedMock.statusCode = 400
        let viewModel = PromotionGateWayViewModel(authManager: mockAuthenticator, forceClient: forceClient)
        await viewModel.enroll(contactId: "")
        XCTAssertNotNil(viewModel.displayError)
        ReferralMockNetworkManager.sharedMock.statusCode = 200
    }
    
    @MainActor func test_enrollWithContactId() async throws {
        await viewModel.enroll(contactId: "")
        XCTAssertEqual(viewModel.promotionScreenType, .referFriend)
    }
    
    @MainActor func test_getPromotionType() async throws {
        await viewModel.getPromotionType(promotionId: "Temp", contactId: "")
        XCTAssertEqual(viewModel.promotionScreenType, .loyaltyPromotion)
    }
    
    @MainActor func test_checkEnrollmentStatus() async throws {
        ReferralMockNetworkManager.sharedMock.statusCode = 200
        await viewModel.checkEnrollmentStatus(contactId: "", promotionCode: "")
        XCTAssertEqual(viewModel.promotionScreenType, .loyaltyPromotion)
    }

}
