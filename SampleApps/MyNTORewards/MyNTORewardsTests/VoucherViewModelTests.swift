//
//  VoucherViewModelTests.swift
//  MyNTORewardsTests
//
//  Created by Anandhakrishnan Kanagaraj on 09/03/23.
//

import XCTest
@testable import MyNTORewards
@testable import LoyaltyMobileSDK

final class VoucherViewModelTests: XCTestCase {

    var viewModel: VoucherViewModel!

    @MainActor override func setUp() {
        super.setUp()
        let mockAuthenticator = MockAuthenticator.sharedMock
        viewModel = VoucherViewModel(authManager: mockAuthenticator, localFileManager: MockFileManager.mockInstance)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchVouchers() async throws {
        let vouchers = try await viewModel.fetchVouchers(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(vouchers.count == 4)
        XCTAssertTrue(vouchers[0].discountPercent == 50)
        XCTAssertTrue(vouchers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(vouchers[0].id == "0kDRO00000000Hk2AI")
        XCTAssertTrue(vouchers[1].discountPercent == 40)
        XCTAssertTrue(vouchers[1].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(vouchers[1].id == "0kDRO00000000Hp2AI")
    }
    
    @MainActor func testLoadVoucher() async throws {
        viewModel.clear()
        MockFileManager.mockInstance.clear()
        try await viewModel.loadVouchers(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.vouchers.count == 2)
        
        
        try await viewModel.loadVouchers(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.vouchers.count == 2)
        XCTAssertTrue(viewModel.vouchers[0].discountPercent == 50)
        XCTAssertTrue(viewModel.vouchers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.vouchers[0].id == "0kDRO00000000Hk2AI")
        XCTAssertTrue(viewModel.vouchers[1].discountPercent == 40)
        XCTAssertTrue(viewModel.vouchers[1].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.vouchers[1].id == "0kDRO00000000Hp2AI")
    }
    
    @MainActor func testReloadVouchers() async throws {
        try await viewModel.reloadVouchers(membershipNumber: "1234", devMode: true)
        XCTAssertTrue(viewModel.vouchers.count == 2)
        XCTAssertTrue(viewModel.vouchers[0].discountPercent == 50)
        XCTAssertTrue(viewModel.vouchers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.vouchers[0].id == "0kDRO00000000Hk2AI")
        XCTAssertTrue(viewModel.vouchers[1].discountPercent == 40)
        XCTAssertTrue(viewModel.vouchers[1].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.vouchers[1].id == "0kDRO00000000Hp2AI")
    }
    
    @MainActor func testFilteredVocuher() async throws {
        let vouchers = try await viewModel.loadFilteredVouchers(membershipNumber: "1234", filter: .Issued, devMode: true)
        XCTAssertTrue(vouchers.count == 1)
        XCTAssertTrue(vouchers[0].discountPercent == 50)
        XCTAssertTrue(vouchers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(vouchers[0].id == "0kDRO00000000Hk2AI")
    }

    @MainActor func testReloadFilteredVouchers() async throws {
        let vouchers = try await viewModel.reloadFilteredVouchers(membershipNumber: "1234", filter: .Expired, devMode: true)
        XCTAssertTrue(vouchers.count == 1)
        XCTAssertTrue(vouchers[0].discountPercent == 40)
        XCTAssertTrue(vouchers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(vouchers[0].id == "0kD43872679RO00000000Hp2AI")
    }
    
    @MainActor func testLoadAvailableVouchers() async throws {
        try await viewModel.loadAvailableVouchers(membershipNumber: "1234", reload: false, devMode: true)
        XCTAssertTrue(viewModel.availableVochers.count == 1)
        XCTAssertTrue(viewModel.availableVochers[0].discountPercent == 50)
        XCTAssertTrue(viewModel.availableVochers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.availableVochers[0].id == "0kDRO00000000Hk2AI")
        
        /// Test with reload True
        viewModel.clear()
        XCTAssertTrue(viewModel.availableVochers.count == 0)
        try await viewModel.loadAvailableVouchers(membershipNumber: "1234", reload: true, devMode: true)
        XCTAssertTrue(viewModel.availableVochers.count == 1)
    }
    
    @MainActor func testLoadExpiredVouchers() async throws {
        try await viewModel.loadExpiredVouchers(membershipNumber: "1234", reload: false, devMode: true)
        XCTAssertTrue(viewModel.expiredVochers.count == 1)
        XCTAssertTrue(viewModel.expiredVochers[0].discountPercent == 40)
        XCTAssertTrue(viewModel.expiredVochers[0].description == "20% discount on children group party at selected event centers.")
        XCTAssertTrue(viewModel.expiredVochers[0].id == "0kD43872679RO00000000Hp2AI")
        
        /// Test with reload True
        viewModel.clear()
        XCTAssertTrue(viewModel.availableVochers.count == 0)
        try await viewModel.loadExpiredVouchers(membershipNumber: "1234", reload: true, devMode: true)
        XCTAssertTrue(viewModel.expiredVochers.count == 1)
    }
    
    @MainActor func testLoadRedemmedVouchers() async throws {
        try await viewModel.loadRedeemedVouchers(membershipNumber: "1234", reload: false, devMode: true)
        XCTAssertTrue(viewModel.expiredVochers.isEmpty)
        
        /// Test with reload True
        viewModel.clear()
        try await viewModel.loadRedeemedVouchers(membershipNumber: "1234", reload: true, devMode: true)
        XCTAssertTrue(viewModel.expiredVochers.isEmpty)
    }
}
