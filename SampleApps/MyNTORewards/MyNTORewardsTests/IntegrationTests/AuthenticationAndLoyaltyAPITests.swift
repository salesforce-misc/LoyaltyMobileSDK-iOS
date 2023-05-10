//
//  AuthenticationAndLoyaltyAPITests.swift
//  MyNTORewardsTests
//
//  Created by Vasanthkumar Velusamy on 02/05/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class AuthenticationAndLoyaltyAPITests: XCTestCase {
	var benefitViewModel: BenefitViewModel!
	var profileViewModel: ProfileViewModel!
	var promotionViewModel: PromotionViewModel!
	var transactionsViewModel: TransactionViewModel!
	var voucherViewModel: VoucherViewModel!
	var appRootViewModel: AppRootViewModel!
	
	@MainActor override func setUp() async throws {
		try await super.setUp()
		benefitViewModel = BenefitViewModel()
		profileViewModel = ProfileViewModel()
		promotionViewModel = PromotionViewModel()
		transactionsViewModel = TransactionViewModel()
		voucherViewModel = VoucherViewModel()
		appRootViewModel = AppRootViewModel()
		try await appRootViewModel.signInUser(userEmail: "q3test@test.com", userPassword: "test@321")
	}
	
	override func tearDown() {
		benefitViewModel = nil
		appRootViewModel = nil
		profileViewModel = nil
		promotionViewModel = nil
		transactionsViewModel = nil
		super.tearDown()
	}
	
	@MainActor func testUserLoginState() async throws {
		XCTAssertEqual(appRootViewModel.userState, .signedIn)
	}
	
	@MainActor func testGetMemberBenefits() async throws {
		XCTAssertTrue(benefitViewModel.benefits.isEmpty)
        if let memberId = appRootViewModel.member?.loyaltyProgramMemberId {
            try await benefitViewModel.getBenefits(memberId: memberId)
        } else {
            XCTFail("Member id not found")
        }
        
		XCTAssertFalse(benefitViewModel.benefits.isEmpty)
	}
	
	@MainActor func testGetProfileData() async throws {
		XCTAssertNil(profileViewModel.profile)
        if let memberId = appRootViewModel.member?.loyaltyProgramMemberId {
		try await profileViewModel.getProfileData(memberId: memberId)
        } else {
            XCTFail("Member id not found")
        }
		XCTAssertNotNil(profileViewModel.profile)
	}
	
	@MainActor func testGetPromotions() async throws {
		XCTAssertTrue(promotionViewModel.allEligiblePromotions.isEmpty)
        if let memberId = appRootViewModel.member?.membershipNumber {
            try await promotionViewModel.fetchAllPromotions(membershipNumber: memberId)
        } else {
            XCTFail("Member id not found")
        }
	}
	
	@MainActor func testGetTransactions() async throws {
		XCTAssertTrue(transactionsViewModel.transactions.isEmpty)
        if let memberId = appRootViewModel.member?.membershipNumber {
            try await transactionsViewModel.loadTransactions(membershipNumber: memberId)
        } else {
            XCTFail("Member id not found")
        }
	}
	
	@MainActor func testGetVouchers() async throws {
		XCTAssertTrue(voucherViewModel.vouchers.isEmpty)
        if let memberId = appRootViewModel.member?.membershipNumber {
            _ = try await voucherViewModel.fetchVouchers(membershipNumber: memberId)
        } else {
            XCTFail("Member id not found")
        }
	}
}
