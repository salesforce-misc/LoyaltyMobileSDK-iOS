/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A class for managing requests related to loyalty programs using the Force API.
public class LoyaltyAPIManager {
    
    /// An instance of `ForceAuthenticator` for authentication
    public var auth: ForceAuthenticator
    
    /// The name of the loyalty program
    public var loyaltyProgramName: String
    
    /// The base URL of the loyalty program API
    public var instanceURL: String
    
    /// An instance of `ForceClient` to handle API requests
    private var forceClient: ForceClient
    
    /// Initializes a `LoyaltyAPIManager` with the necessary parameters.
    public init(auth: ForceAuthenticator, loyaltyProgramName: String, instanceURL: String, forceClient: ForceClient) {
        self.auth = auth
        self.loyaltyProgramName = loyaltyProgramName
        self.instanceURL = instanceURL
        self.forceClient = forceClient
    }

    /// Enumeration for sorting the results by a specific field.
    public enum SortBy: String {
        case expirationDate
        case effectiveDate
        case createdDate
    }
    
    /// Enumeration for specifying the sort order of the results.
    public enum SortOrder: String {
        case ascending
        case descending
    }
    
    /// Enumeration for the status of a voucher.
    public enum VoucherStatus: String {
        case issued
        case cancelled
        case expired
    }
    
    /// Enumeration for identifying the type of resource to request.
    public enum Resource {
        case individualEnrollment(programName: String, version: String)
        case getMemberBenefits(memberId: String, version: String)
        case getMemberProfile(programName: String, version: String)
        case getTransactionHistory(programName: String, memberId: String, version: String)
        case getPromotions(programName: String, version: String)
        case enrollInPromotion(programName: String, version: String)
        case unenrollPromotion(programName: String, version: String)
        case getVouchers(programName: String, membershipNumber: String, version: String)
        case getGames(memberId: String, version: String)

    }
    
    /// Get path for given API resource
    /// - Parameter resource: A ``Resource``
    /// - Returns: A string represents URL path of the resource
    public func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .individualEnrollment(let programName, let version):
            return ForceAPI.path(for: "loyalty-programs/\(programName)/individual-member-enrollments", version: version)
        case .getMemberBenefits(let memberId, let version):
            return ForceAPI.path(for: "connect/loyalty/member/\(memberId)/memberbenefits", version: version)
        case .getMemberProfile(let programName, let version):
            return ForceAPI.path(for: "loyalty-programs/\(programName)/members", version: version)
        case .getTransactionHistory(let programName, let memberId, let version):
            return ForceAPI.path(for: "loyalty/programs/\(programName)/members/\(memberId)/transaction-ledger-summary", version: version)
        case .getPromotions(let programName, let version):
            return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/GetMemberPromotions", version: version)
        case .enrollInPromotion(let programName, let version):
            return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/EnrollInPromotion", version: version)
        case .unenrollPromotion(let programName, let version):
			return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/OptOutOfPromotion", version: version)
        case .getVouchers(let programName, let membershipNumber, let version):
            return ForceAPI.path(for: "loyalty/programs/\(programName)/members/\(membershipNumber)/vouchers", version: version)
        case .getGames(memberId: let memberId, version: let version):
            return ForceAPI.path(for: "game/participant/\(memberId)/Games", version: version)
        }
    
    }
    
    /// Get Member Benefits - Makes an asynchronous request for data from the Salesforce
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_member_benefits.htm
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``BenefitModel`` array
    public func getMemberBenefits(
        for memberId: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> [BenefitModel] {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: Benefits.self, file: "Benefits")
                return result.memberBenefits
            }
            let path = getPath(for: .getMemberBenefits(memberId: memberId, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET")
            let result = try await forceClient.fetch(type: Benefits.self, with: request)
            return result.memberBenefits
        } catch {
            throw error
        }
    }
    
    /// Get Member Profile - Makes an asynchronous request for data from the Salesforce
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_member_profile.htm
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``ProfileModel`` instance
    public func getMemberProfile(
        for memberId: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> ProfileModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: ProfileModel.self, file: "Profile")
                return result
            }
            let path = getPath(for: .getMemberProfile(programName: loyaltyProgramName, version: version))
            let queryItems = ["memberId": "\(memberId)"]
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET", queryItems: queryItems)
            return try await forceClient.fetch(type: ProfileModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    /// Get Community Member Profile - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``ProfileModel`` instance
    public func getCommunityMemberProfile(
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> ProfileModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: ProfileModel.self, file: "Profile")
                return result
            }
            let path = getPath(for: .getMemberProfile(programName: loyaltyProgramName, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET")
            return try await forceClient.fetch(type: ProfileModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    /// Enroll a member to a Loyalty Program
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_enroll_individual_member.htm
    /// - Parameters:
    ///   - membershipNumber: The memership number for the loyalty program
    ///   - firstName: The first name
    ///   - lastName: The last name
    ///   - email: The email address
    ///   - phone: The phone number
    ///   - emailNotification: Whether subscribe to the mailinglist
    ///   - version: The API version number
    /// - Returns: A ``EnrollmentOutputModel`` instance
    public func postEnrollment(
        membershipNumber: String,
        firstName: String,
        lastName: String,
        email: String, phone: String,
        emailNotification: Bool,
        version: String = LoyaltyAPIVersion.defaultVersion) async throws -> EnrollmentOutputModel {
        
        let currentDate = Date()
        let attributesContact = ["Phone": phone]
        // let attributesContact = ["Phone": phone, "HasOptedOutOfEmail": String(!emailNotification)]
        let additionalContactValues = AdditionalFieldValues(attributes: attributesContact)
        let additionalMemberValues = AdditionalFieldValues(attributes: [:])
        let contactDetails = AssociatedContactDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            allowDuplicateRecords: false,
            additionalContactFieldValues: additionalContactValues)
        
        let enrollment = EnrollmentModel(
            enrollmentDate: currentDate,
            membershipNumber: membershipNumber,
            associatedContactDetails: contactDetails,
            memberStatus: "Active",
            referredBy: nil,
            createTransactionJournals: true,
            transactionJournalStatementFrequency: "Monthly",
            transactionJournalStatementMethod: "Mail",
            enrollmentChannel: "Email",
            canReceivePromotions: true,
            canReceivePartnerPromotions: true,
            membershipEndDate: nil,
            relatedCorporate​MembershipNumber: nil,
            additionalMemberFieldValues: additionalMemberValues)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.forceFormatter())
            let requestBody = try encoder.encode(enrollment)
            if let requestJson = String(data: requestBody, encoding: .utf8) {
                Logger.debug(requestJson)
            }
            let path = getPath(for: .individualEnrollment(programName: loyaltyProgramName, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: requestBody)
            return try await forceClient.fetch(type: EnrollmentOutputModel.self, with: request)
            
        } catch {
            throw error
        }
        
    }
    
    /// Enroll into a promotion
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_enroll_ln_promotion.htm
    /// - Parameters:
    ///   - promotionName: The promotion name
    ///   - membershipNumber: The membership number
    ///   - version: The API version number
    public func enrollIn(
        promotion promotionName: String,
        for membershipNumber: String,
        version: String = LoyaltyAPIVersion.defaultVersion) async throws {
        let body = [
            "processParameters": [
                [
                    "MembershipNumber": membershipNumber,
                    "PromotionName": promotionName
                ]
            ]
        ]
        
        do {
            let path = getPath(for: .enrollInPromotion(programName: loyaltyProgramName, version: version))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            _ = try await forceClient.fetch(type: EnrollPromotionOutputModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    /// Unroll from a promotion
    /// - Parameters:
    ///   - promotionId: The promotion ID
    ///   - membershipNumber: The membership Number
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
	public final func unenroll(
        promotionId: String,
        for membershipNumber: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws {
		let body = [
			"processParameters": [
				[
					"MembershipNumber": membershipNumber,
					"PromotionId": promotionId
				]
			]
		]
        try await unenroll(requestBody: body, version: version, devMode: devMode)
	}
    
    /// Unroll from a promotion
    /// - Parameters:
    ///   - promotionName: The promotion name
    ///   - membershipNumber: The membership Number
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
	public final func unenroll(
        promotionName: String,
        for membershipNumber: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws {
		let body = [
			"processParameters": [
				[
					"MembershipNumber": membershipNumber,
					"PromotionName": promotionName
				]
			]
		]
		try await unenroll(requestBody: body, version: version, devMode: devMode)
	}
    
	private func unenroll(
        requestBody: [String: Any],
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws {
		if devMode {
			_ = try forceClient.fetchLocalJson(type: UnenrollPromotionResponseModel.self, file: "UnenrollmentPromotion")
			return
		}
		
		do {
			let path = getPath(for: .unenrollPromotion(programName: loyaltyProgramName, version: version))
			let bodyJsonData = try JSONSerialization.data(withJSONObject: requestBody)
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
			let response = try await forceClient.fetch(type: UnenrollPromotionResponseModel.self, with: request)
			if !response.status {
				throw CommonError.requestFailed(message: response.message ?? "Unknown")
			}
		} catch {
			throw error
		}
	}
    
    /// Get promotions for the loyalty member
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_enroll_ln_promotion.htm
    /// - Parameters:
    ///   - memberId: The member ID
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``PromotionModel`` instance
    public func getPromotions(
        memberId: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MemberId": memberId]
            ]
        ]
        return try await getPromotions(requsetBody: body, version: version, devMode: devMode)
    }
    
    /// Get promotions for the loyalty member
    /// Reference: https://developer.salesforce.com/docs/atlas.en-us.loyalty.meta/loyalty/connect_resources_enroll_ln_promotion.htm
    /// - Parameters:
    ///   - membershipNumber: The membership number
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``PromotionModel`` instance
    public func getPromotions(
        membershipNumber: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MembershipNumber": membershipNumber]
            ]
        ]
        return try await getPromotions(requsetBody: body, version: version, devMode: devMode)
    }
    
    private func getPromotions(requsetBody: [String: Any],
                               version: String = LoyaltyAPIVersion.defaultVersion,
                               devMode: Bool = false) async throws -> PromotionModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: PromotionModel.self, file: "Promotions")
                return result
            }
            let path = getPath(for: .getPromotions(programName: loyaltyProgramName, version: version))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: requsetBody)
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "POST", body: bodyJsonData)
            let result = try await forceClient.fetch(type: PromotionModel.self, with: request)
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Get Transactions - Makes an asynchronous request for transactions data from the Salesforce
    /// - Parameters:
    ///   - for membershipNumber: The membership number of the loyalty program member whose transaction journals are retrieved.
    ///   - pageNumber: Number of the page you want returned. If you don’t specify a value, the first page is returned. Each page contains 200 transaction journals and the transaction journals are sorted based on the date on which the Transaction Journal record was created.
    ///  - journelType: The journal type of transaction journals that are retrieved.
    ///  - journalSubType: The journal subtype of transaction journals that are retrieved.
    ///  - periodStartDate: Retrieve transaction journals until this date.
    ///  - periodEndDate: Retrieve transaction journals until this date.
    /// - Returns: A ``TransactionModel`` instance
    public func getTransactions(
        for membershipNumber: String,
        pageNumber: Int? = nil,
        journalTypeName: String? = nil,
        journalSubTypeName: String? = nil,
        periodStartDate: String? = nil,
        periodEndDate: String? = nil,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> [TransactionJournal] {
        let pageNumberString = pageNumber == nil ? nil : String(describing: pageNumber)
        let queryItems = ["pageNumber": pageNumberString,
                          "journalTypeName": journalTypeName,
                          "journalSubTypeName": journalSubTypeName,
                          "periodStartDate": periodStartDate,
                          "periodEndDate": periodEndDate ].compactMapValues { $0 }
        
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: TransactionModel.self, file: "Transactions")
                return result.transactionJournals
            }
            let path = getPath(for: .getTransactionHistory(programName: loyaltyProgramName, memberId: membershipNumber, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET", queryItems: queryItems)
            let result = try await forceClient.fetch(type: TransactionModel.self, with: request)
            return result.transactionJournals
        } catch {
            throw error
        }
    }
    
    /// Get vouchers information for the loyalty member
    /// - Parameters:
    ///   - membershipNumber: The membership number of the loyalty program member whose issued vouchers are retrieved.
    ///   - voucherStatus: The list of statuses for which you want to the get member's vouchers.
    ///   - pageNumber: Number of the page you want returned. If you don’t specify a value, the first page is returned. Each page contains 200 vouchers and the vouchers are sorted based on the date on which the Voucher record was created.
    ///   - productId: The ID of products that are related with the member vouchers you want to get. You can specify the ID of up to 20 products.
    ///   - productCategoryId: The ID of product categories that are related with the member vouchers you want to get. You can specify the ID of up to 20 product categories.
    ///   - productName: The product name
    ///   - productCategoryName: The names of product categories that are related with the member vouchers you want to get. You can specify the ID of up to 20 product categories.
    ///   - sortBy: Specifies the Voucher field that's used to sort the vouchers you want to get. The default value is ExpirationDate.
    ///   - sortOrder: Specifies the sort order of the vouchers you want to get. The default value is Ascending.
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``VoucherModel`` array
	public func getVouchers(
        membershipNumber: String,
        voucherStatus: [VoucherStatus]? = nil,
        pageNumber: Int? = nil,
        productId: [String]? = nil,
        productCategoryId: [String]? = nil,
        productName: [String]? = nil,
        productCategoryName: [String]? = nil,
        sortBy: SortBy? = nil,
        sortOrder: SortOrder? = nil,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> [VoucherModel] {
		do {
			if devMode {
				let result = try forceClient.fetchLocalJson(type: VouchersResponse.self, file: "Vouchers")
				return result.vouchers ?? []
			}
			let queries = [
				"voucherStatus": getString(from: voucherStatus?.map {$0.rawValue}),
				"pageNumber": getString(from: pageNumber),
				"productId": getString(from: productId),
				"productCategoryId": getString(from: productCategoryId),
				"productName": getString(from: productName),
				"productCategoryName": getString(from: productCategoryName),
				"sortBy": getString(from: sortBy),
				"sortOrder": getString(from: sortOrder)
			].compactMapValues { $0 }

            let path = getPath(for: .getVouchers(programName: loyaltyProgramName, membershipNumber: membershipNumber, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET", queryItems: queries)
			let result = try await forceClient.fetch(type: VouchersResponse.self, with: request)
			return result.vouchers ?? []
		} catch {
            Logger.error(error.localizedDescription)
			throw error
		}
	}
	
    private final func getString(from query: Any?) -> String? {
        guard let query = query else { return nil }
        
        switch query {
        case let query as [String]:
            return query.joined(separator: ",")
        case let query as Int:
            return String(query)
        case let query as SortBy:
            return query.rawValue
        case let query as SortOrder:
            return query.rawValue
        default:
            return nil
        }
    }
    
    /// Get Games information for the loyalty member
    /// - Parameters:
    ///   - membershipId: The membership number of the loyalty program member whose issued vouchers are retrieved.
    ///   - version: The API version number
    ///   - devMode: Whether it's in devMode
    /// - Returns: A ``GamesResponseModel`` object
    public func getGames(
        membershipId: String,
        version: String = LoyaltyAPIVersion.defaultVersion,
        devMode: Bool = false) async throws -> GamesResponseModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: GamesResponseModel.self, file: "GetGames")
                return result
            }
            let path = getPath(for: .getGames(memberId: membershipId, version: version))
            let request = try ForceRequest.create(instanceURL: instanceURL, path: path, method: "GET")
            let result = try await forceClient.fetch(type: GamesResponseModel.self, with: request)
            return result
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
    
    
}
