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
    
    var needToThrowError = false
    
    func getAccessToken() -> String? {
        guard !needToThrowError else { return nil }
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
                                              instanceURL: "https://instanceUrl",
                                              forceClient: ForceClient(auth: MockAuthenticator.sharedMock,
                                                                       forceNetworkManager: MockNetworkManager.sharedMock))
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
        
        /// Verifying dev Mode
        let devIdentity = try await loayltyAPIManager.getMemberProfile(for: "MRI706", devMode: true)

        XCTAssertNotNil(devIdentity)
        XCTAssertEqual(devIdentity.associatedContact.firstName, "Aman")
        XCTAssertEqual(devIdentity.associatedContact.lastName, "Bindal")
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getMemberProfile(for: "MRI706")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testCommunityMemberProfile() async throws {
        var identity = try await loayltyAPIManager.getCommunityMemberProfile()

        XCTAssertNotNil(identity)
        XCTAssertEqual(identity.associatedContact.firstName, "Aman")
        XCTAssertEqual(identity.associatedContact.lastName, "Bindal")
        
        /// Verifying dev Mode
        identity = try await loayltyAPIManager.getCommunityMemberProfile(devMode: true)
        
        XCTAssertNotNil(identity)
        XCTAssertEqual(identity.associatedContact.firstName, "Aman")
        XCTAssertEqual(identity.associatedContact.lastName, "Bindal")
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getCommunityMemberProfile()
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testGetMemberBenefits() async throws {
        var benefits = try await loayltyAPIManager.getMemberBenefits(for: "1234")

        XCTAssertEqual(benefits.count, 6)
        XCTAssertEqual(benefits[0].id, "0ji4x0000008REdAAM")
        XCTAssertEqual(benefits[1].id, "0ji4x0000008REjAAM")
        XCTAssertEqual(benefits[2].id, "0ji4x0000008REeAAM")
        XCTAssertEqual(benefits[3].id, "0ji4x0000008REZAA2")
        XCTAssertEqual(benefits[4].id, "0ji4x0000008REiAAM")
        XCTAssertEqual(benefits[5].id, "0ji4x0000008REfAAM")
        
        /// Verifying dev Mode
        benefits = try await loayltyAPIManager.getMemberBenefits(for: "1234", devMode: true)

        XCTAssertEqual(benefits.count, 6)
        XCTAssertEqual(benefits[0].id, "0ji4x0000008REdAAM")
        XCTAssertEqual(benefits[1].id, "0ji4x0000008REjAAM")
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getMemberBenefits(for: "1234")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }

    func testPostEnrollement() async throws {
        let enrollment = try await loayltyAPIManager.postEnrollment(membershipNumber: "1234",
                                                                    firstName: "testFirstName",
                                                                    lastName: "testSecondName",
                                                                    email: "test@mail.com",
                                                                    phone: "12335699",
                                                                    emailNotification: false)
        
        XCTAssertEqual(enrollment.contactId, "0034x00001JdPg6")
        XCTAssertEqual(enrollment.loyaltyProgramName, "NTO Insider")
        XCTAssertEqual(enrollment.loyaltyProgramMemberId, "0lM4x000000LOrM")
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.postEnrollment(membershipNumber: "1234",
                                                           firstName: "testFirstName",
                                                           lastName: "testSecondName",
                                                           email: "test@mail.com",
                                                           phone: "12335699",
                                                           emailNotification: false)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }

    func testEnrollIn() async throws {
        do {
            let enrollPromotionModel: () = try await loayltyAPIManager.enrollIn(promotion: "health", for: "1234")
            XCTAssertNotNil(enrollPromotionModel)
        } catch {
            XCTFail("Enroll promotion not complete successfully.")
        }
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.enrollIn(promotion: "health", for: "1234")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }

    func testUnenrollIn() async throws {
        do {
            let unenrollPromotionModel: () = try await loayltyAPIManager.unenroll(promotionName: "Health", for: "1234")
            XCTAssertNotNil(unenrollPromotionModel)
        } catch {
            XCTFail("unEnroll promotion not complete successfully.")
        }
        
        let unenrollPromotionModel: () = try await loayltyAPIManager.unenroll(promotionName: "Health", for: "1234", devMode: true)
        XCTAssertNotNil(unenrollPromotionModel)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.unenroll(promotionName: "Health", for: "1234")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testUnenrollPromotionId() async throws {
        do {
            let unenrollPromotionModel: () = try await loayltyAPIManager.unenroll(promotionId: "3456", for: "Health")
            XCTAssertNotNil(unenrollPromotionModel)
        } catch {
            XCTFail("unEnroll promotion not complete successfully.")
        }
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.unenroll(promotionId: "3456", for: "Health")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
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
        
        /// Verifying dev Mode
        promotions = try await loayltyAPIManager.getPromotions(memberId: "1234", devMode: true)
        XCTAssertEqual(promotions.status, true)
        XCTAssertEqual(promotions.outputParameters.outputParameters.results.count, 8)
        XCTAssertNil(promotions.message)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getPromotions(memberId: "1234")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }

    func testGetTransactions() async throws {
        var transactions = try await loayltyAPIManager.getTransactions(for: "1234")
        XCTAssertEqual(transactions.count, 4)
        XCTAssertEqual(transactions[0].journalTypeName, "Manual Points Adjustment")
        XCTAssertEqual(transactions[0].id, "0lVRO00000002og2AA")
        XCTAssertEqual(transactions[0].activityDate, "2023-04-08T04:59:40.000Z")
        
        XCTAssertEqual(transactions[1].journalTypeName, "Manual Points Adjustment")
        XCTAssertEqual(transactions[1].id, "0lVRO00000002ob2AA")
        XCTAssertEqual(transactions[1].activityDate, "2023-04-08T04:58:07.000Z")
        
        /// Verifying dev Mode
        transactions = try await loayltyAPIManager.getTransactions(for: "1234", devMode: true)
        XCTAssertEqual(transactions.count, 4)
        XCTAssertEqual(transactions[0].journalTypeName, "Manual Points Adjustment")
        XCTAssertEqual(transactions[0].id, "0lVRO00000002og2AA")
        XCTAssertEqual(transactions[0].activityDate, "2023-04-08T04:59:40.000Z")
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getTransactions(for: "1234")
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
    func testGetVouchers() async throws {
        var vouchers = try await loayltyAPIManager.getVouchers(membershipNumber: "1234",
                                                               pageNumber: 1,
                                                               productId: ["0kD4x000000wr6THAK", "0kD4x003000wr6EEAQ"],
                                                               sortBy: .expirationDate,
                                                               sortOrder: .ascending)
        XCTAssertEqual(vouchers.count, 4)
        XCTAssertEqual(vouchers[0].id, "0kDRO00000000Hk2AI")
        XCTAssertEqual(vouchers[0].discountPercent, 50)
        
        XCTAssertEqual(vouchers[1].id, "0kDRO00000000Hp2AI")
        XCTAssertEqual(vouchers[1].discountPercent, 40)
        
        XCTAssertEqual(vouchers[2].id, "0kDRO00000000Hp2BI")
        XCTAssertEqual(vouchers[2].discountPercent, 40)
        
        /// Verifying dev Mode
        vouchers = try await loayltyAPIManager.getVouchers(membershipNumber: "1234", pageNumber: 1, devMode: true)
        XCTAssertEqual(vouchers.count, 4)
        XCTAssertEqual(vouchers[0].id, "0kDRO00000000Hk2AI")
        XCTAssertEqual(vouchers[0].discountPercent, 50)
        
        XCTAssertEqual(vouchers[1].id, "0kDRO00000000Hp2AI")
        XCTAssertEqual(vouchers[1].discountPercent, 40)
        
        XCTAssertEqual(vouchers[2].id, "0kDRO00000000Hp2BI")
        XCTAssertEqual(vouchers[2].discountPercent, 40)
        
        // Handle authentication failed scenrio
        MockNetworkManager.sharedMock.statusCode = 401
        do {
            _ = try await loayltyAPIManager.getVouchers(membershipNumber: "1234",
                                                        pageNumber: 1,
                                                        productId: ["0kD4x000000wr6THAK", "0kD4x003000wr6EEAQ"],
                                                        sortBy: .expirationDate,
                                                        sortOrder: .ascending)
        } catch {
            guard let commonError = error as? CommonError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(commonError, CommonError.authenticationNeeded)
        }
    }
    
}
