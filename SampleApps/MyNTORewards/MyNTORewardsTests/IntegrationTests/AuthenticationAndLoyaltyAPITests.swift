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
		try await benefitViewModel.getBenefits(memberId: appRootViewModel.member!.loyaltyProgramMemberId)
		XCTAssertFalse(benefitViewModel.benefits.isEmpty)
	}
	
	@MainActor func testGetProfileData() async throws {
		XCTAssertNil(profileViewModel.profile)
		try await profileViewModel.getProfileData(memberId: appRootViewModel.member!.loyaltyProgramMemberId)
		XCTAssertNotNil(profileViewModel.profile)
	}
	
	@MainActor func testGetPromotions() async throws {
		XCTAssertTrue(promotionViewModel.allEligiblePromotions.isEmpty)
		_ = try await promotionViewModel.fetchAllPromotions(membershipNumber: appRootViewModel.member!.membershipNumber)
	}
	
	@MainActor func testGetTransactions() async throws {
		XCTAssertTrue(transactionsViewModel.transactions.isEmpty)
		_ = try await transactionsViewModel.loadTransactions(membershipNumber: appRootViewModel.member!.membershipNumber)
	}
	
	@MainActor func testGetVouchers() async throws {
		XCTAssertTrue(voucherViewModel.vouchers.isEmpty)
		_ = try await voucherViewModel.fetchVouchers(membershipNumber: appRootViewModel.member!.membershipNumber)
	}
}
