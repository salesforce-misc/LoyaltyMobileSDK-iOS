/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import UIKit

public class LoyaltyAPIManager {
    
    public var auth: ForceAuthenticator
    public var loyaltyProgramName: String
    private var forceClient: ForceClient
    
    public init(auth: ForceAuthenticator, loyaltyProgramName: String) {
        self.auth = auth
        self.loyaltyProgramName = loyaltyProgramName
        self.forceClient = ForceClient(auth: auth)
    }
	
	public enum SortBy: String {
		case ExpirationDate
		case EffectiveDate
		case CreatedDate
	}
	
	public enum SortOrder: String {
		case Ascending
		case Descending
	}
	
	public enum VoucherStatus: String {
		case Issued
		case Cancelled
		case Expired
	}
    
    public enum Resource {
        case individualEnrollment(programName: String, version: String)
        case getMemberBenefits(memberId: String, version: String)
        case getMemberProfile(programName: String, version: String)
        case getTransactionHistory(programName: String, memberId: String, version: String)
        case getPromotions(programName: String, version: String)
        case enrollInPromotion(programName: String, version: String)
		case unenrollPromotion(programName: String, version: String)
		case getVouchers(programName: String, membershipNumber: String, version: String)
    }
    
    public func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .individualEnrollment(let programName, let version):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/individual-member-enrollments", version: version)
        case .getMemberBenefits(let memberId, let version):
            return ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits", version: version)
        case .getMemberProfile(let programName, let version):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/members", version: version)
        case .getTransactionHistory(let programName, let memberId, let version):
            return ForceConfig.path(for: "loyalty/programs/\(programName)/members/\(memberId)/transaction-ledger-summary", version: version)
        case .getPromotions(let programName, let version):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/GetMemberPromotions", version: version)
        case .enrollInPromotion(let programName, let version):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/EnrollInPromotion", version: version)
		case .unenrollPromotion(let programName, let version):
			return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/OptOutOfPromotion", version: version)
		case .getVouchers(let programName, let membershipNumber, let version):
				return ForceConfig.path(for: "loyalty/programs/\(programName)/members/\(membershipNumber)/vouchers", version: version)
        }
    
    }
    
    /// Get Member Benefits - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    /// - Returns: An ``BenefitModel`` array
    public func getMemberBenefits(for memberId: String,
                                  version: String = ForceConfig.defaultVersion,
                                  devMode: Bool = false) async throws -> [BenefitModel] {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: Benefits.self, file: "Benefits")
                return result.memberBenefits
            }
            let path = getPath(for: .getMemberBenefits(memberId: memberId, version: version))
            let request = try ForceRequest.create(path: path, method: "GET")
            let result = try await forceClient.fetch(type: Benefits.self, with: request)
            return result.memberBenefits
        } catch {
            throw error
        }
    }
    
    /// Get Member Profile - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    ///   - programName: The loytalty program name
    /// - Returns: An ``ProfileModel`` instance
    public func getMemberProfile(for memberId: String,
                                 version: String = ForceConfig.defaultVersion,
                                 devMode: Bool = false) async throws -> ProfileModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: ProfileModel.self, file: "Profile")
                return result
            }
            let path = getPath(for: .getMemberProfile(programName: loyaltyProgramName, version: version))
            let queryItems = ["memberId": "\(memberId)"]
            let request = try ForceRequest.create(path: path, method: "GET", queryItems: queryItems)
            return try await forceClient.fetch(type: ProfileModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    public func postEnrollment(membershipNumber: String,
                               firstName: String,
                               lastName: String,
                               email: String, phone: String,
                               emailNotification: Bool,
                               version: String = ForceConfig.defaultVersion) async throws -> EnrollmentOutputModel {
        
        let currentDate = Date()
        let attributesContact = ["Phone": phone]
        //let attributesContact = ["Phone": phone, "HasOptedOutOfEmail": String(!emailNotification)]
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
                print(requestJson)
            }
            let path = getPath(for: .individualEnrollment(programName: loyaltyProgramName, version: version))
            let request = try ForceRequest.create(path: path, method: "POST", body: requestBody)
            return try await forceClient.fetch(type: EnrollmentOutputModel.self, with: request)
            
        } catch {
            throw error
        }
        
    }
    
    public func enrollIn(promotion promotionName: String,
                         for membershipNumber: String,
                         version: String = ForceConfig.defaultVersion) async throws {
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
            let request = try ForceRequest.create(path: path, method: "POST", body: bodyJsonData)
            let _ = try await forceClient.fetch(type: EnrollPromotionOutputModel.self, with: request)
        } catch {
            throw error
        }
    }
	
	public final func unenroll(promotionId: String,
                               for membershipNumber: String,
                               version: String = ForceConfig.defaultVersion,
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
	
	public final func unenroll(promotionName: String,
                               for membershipNumber: String,
                               version: String = ForceConfig.defaultVersion,
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
    
	private func unenroll(requestBody: [String: Any],
                          version: String = ForceConfig.defaultVersion,
                          devMode: Bool = false) async throws {
		if devMode {
			let _ = try forceClient.fetchLocalJson(type: UnenrollPromotionResponseModel.self, file: "UnenrollPromotion")
			return
		}
		
		do {
			let path = getPath(for: .unenrollPromotion(programName: loyaltyProgramName, version: version))
			let bodyJsonData = try JSONSerialization.data(withJSONObject: requestBody)
            let request = try ForceRequest.create(path: path, method: "POST", body: bodyJsonData)
			let response = try await forceClient.fetch(type: UnenrollPromotionResponseModel.self, with: request)
			if !response.status {
				throw ForceError.requestFailed(description: response.message ?? "Unknown")
			}
		} catch {
			throw error
		}
	}
	
    public func getPromotions(memberId: String,
                              version: String = ForceConfig.defaultVersion,
                              devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MemberId": memberId]
            ]
        ]
        return try await getPromotions(requsetBody: body, version: version, devMode: devMode)
    }
    
    public func getPromotions(membershipNumber: String,
                              version: String = ForceConfig.defaultVersion,
                              devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MembershipNumber": membershipNumber]
            ]
        ]
        return try await getPromotions(requsetBody: body, version:version, devMode: devMode)
    }
    
    private func getPromotions(requsetBody: [String: Any],
                               version: String = ForceConfig.defaultVersion,
                               devMode: Bool = false) async throws -> PromotionModel {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: PromotionModel.self, file: "Promotions")
                return result
            }
            let path = getPath(for: .getPromotions(programName: loyaltyProgramName, version: version))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: requsetBody)
            let request = try ForceRequest.create(path: path, method: "POST", body: bodyJsonData)
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
    /// - Returns: An ``TransactionModel`` instance
    public func getTransactions(for membershipNumber: String,
                                pageNumber: Int? = nil,
                                journalTypeName: String? = nil,
                                journalSubTypeName: String? = nil,
                                periodStartDate: String? = nil,
                                periodEndDate: String? = nil,
                                version: String = ForceConfig.defaultVersion,
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
            let request = try ForceRequest.create(path: path, method: "GET", queryItems: queryItems)
            let result = try await forceClient.fetch(type: TransactionModel.self, with: request)
            return result.transactionJournals
        } catch {
            throw error
        }
    }
	
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
        version: String = ForceConfig.defaultVersion,
        devMode: Bool = false) async throws -> [VoucherModel] {
		do {
			if devMode {
				let result = try forceClient.fetchLocalJson(type: VouchersResponse.self, file: "GetVouchers")
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
            let request = try ForceRequest.create(path: path, method: "GET", queryItems: queries)
			let result = try await forceClient.fetch(type: VouchersResponse.self, with: request)
			return result.vouchers ?? []
		} catch {
			print(error.localizedDescription)
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
}
