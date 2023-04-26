/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import XCTest
@testable import LoyaltyMobileSDK

class MockAuthenticator: ForceAuthenticator {
    static let sharedMock = MockAuthenticator()

    
    func getAccessToken() -> String? {
        return "AccessToken1234"
    }
    
    func grantAccessToken() async throws -> String {
        return "AccessToken1234"
    }
    
}

final class LoyaltyAPIManagerTests: XCTestCase {
    private var loayltyAPIManager: LoyaltyAPIManager!
    
    override func setUp() {
        super.setUp()
        loayltyAPIManager = LoyaltyAPIManager(auth: MockAuthenticator.sharedMock,
                                              loyaltyProgramName: "MYNTO Rewards",
                                              instanceURL: "https://instanceUrl", forceClient: ForceClient(auth: MockAuthenticator.sharedMock, forceNetworkManager: MockNetworkManager.sharedMock))
        MockNetworkManager.sharedMock.statusCode = 200
        
    }
    
    override func tearDown() {
        loayltyAPIManager = nil
        super.tearDown()
    }
        
    func testGetMemberProfile() async throws {
        let identity = try await loayltyAPIManager.getMemberProfile(for: "MRI706")

        XCTAssertNotNil(identity)
        XCTAssertEqual(identity.associatedContact.firstName, "Aman")
        XCTAssertEqual(identity.associatedContact.lastName, "Bindal")
    }
    
    func testGetMemberBenefits() async throws {
        let benefits = try await loayltyAPIManager.getMemberBenefits(for: "1234")

        XCTAssertEqual(benefits.count, 6)
        XCTAssertEqual(benefits[0].id, "0ji4x0000008REdAAM")
        XCTAssertEqual(benefits[1].id, "0ji4x0000008REjAAM")
        XCTAssertEqual(benefits[2].id, "0ji4x0000008REeAAM")
        XCTAssertEqual(benefits[3].id, "0ji4x0000008REZAA2")
        XCTAssertEqual(benefits[4].id, "0ji4x0000008REiAAM")
        XCTAssertEqual(benefits[5].id, "0ji4x0000008REfAAM")
    }

    func testPostEnrollement() async throws {
        let enrollment = try await loayltyAPIManager.postEnrollment(membershipNumber: "1234", firstName: "testFirstName", lastName: "testSecondName", email: "test@mail.com", phone: "12335699", emailNotification: false)
        
        XCTAssertEqual(enrollment.contactId, "0034x00001JdPg6")
        XCTAssertEqual(enrollment.loyaltyProgramName, "NTO Insider")
        XCTAssertEqual(enrollment.loyaltyProgramMemberId, "0lM4x000000LOrM")

    }

    func testEnrollIn() async throws {
        do {
            let enrollPromotionModel: () = try await loayltyAPIManager.enrollIn(promotion: "health", for: "1234")
            XCTAssertNotNil(enrollPromotionModel)
        } catch {
            XCTFail("Enroll promotion not complete successfully.")
        }
    }

    func testUnenrollIn() async throws {
        do {
            let unenrollPromotionModel: () = try await loayltyAPIManager.unenroll(promotionName: "Health", for: "1234")
            XCTAssertNotNil(unenrollPromotionModel)
        } catch {
            XCTFail("unEnroll promotion not complete successfully.")
        }
    }

    func testGetPromotions() async throws {
        var promotions = try await loayltyAPIManager.getPromotions(memberId: "1234")
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
        promotions = try await loayltyAPIManager.getPromotions(membershipNumber: "1234")
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
    }

    func testGetTransactions() async throws {
        let transactions = try await loayltyAPIManager.getTransactions(for: "1234")
        XCTAssertEqual(transactions.count, 4)
        XCTAssertEqual(transactions[0].journalTypeName, "Manual Points Adjustment")
        XCTAssertEqual(transactions[0].id, "0lVRO00000002og2AA")
        XCTAssertEqual(transactions[0].activityDate, "2023-03-08T04:59:40.000Z")
        
        XCTAssertEqual(transactions[1].journalTypeName, "Manual Points Adjustment")
        XCTAssertEqual(transactions[1].id, "0lVRO00000002ob2AA")
        XCTAssertEqual(transactions[1].activityDate, "2023-03-08T04:58:07.000Z")
    }
    
    func testGetVouchers() async throws {
        let vouchers = try await loayltyAPIManager.getVouchers(membershipNumber: "1234")
        XCTAssertEqual(vouchers.count, 6)
        XCTAssertEqual(vouchers[0].id, "0kD4x000000wr6THAK")
        XCTAssertEqual(vouchers[0].faceValue, 100)
        
        XCTAssertEqual(vouchers[1].id, "0kD4x003000wr6EEAQ")
        XCTAssertEqual(vouchers[1].discountPercent, 25)
        
        XCTAssertEqual(vouchers[5].id, "0kD4x004000wr6FUNS")
        XCTAssertEqual(vouchers[5].faceValue, 80.0)
    }
    
}
