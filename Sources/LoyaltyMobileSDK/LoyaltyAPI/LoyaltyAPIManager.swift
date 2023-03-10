/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import UIKit

public class LoyaltyAPIManager {
	
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
    
    public static let shared = LoyaltyAPIManager()
    
    // TODO: move to a app config or other places
    private let loyaltyProgramName = "NTO Insider"
    
    private init() {}
    
    public enum Resource {
        case individualEnrollment(programName: String)
        case getMemberBenefits(memberId: String)
        case getMemberProfile(programName: String)
        case getTransactionHistory(programName: String, memberId: String)
        case getPromotions(programName: String)
        case enrollInPromotion(programName: String)
		case unenrollPromotion(programName: String)
		case getVouchers(programName: String, membershipNumber: String)
    }
    
    public func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .individualEnrollment(let programName):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/individual-member-enrollments")
        case .getMemberBenefits(let memberId):
            return ForceConfig.path(for: "connect/loyalty/member/\(memberId)/memberbenefits")
        case .getMemberProfile(let programName):
            return ForceConfig.path(for: "loyalty-programs/\(programName)/members")
        case .getTransactionHistory(let programName, let memberId):
            return ForceConfig.path(for: "loyalty/programs/\(programName)/members/\(memberId)/transaction-ledger-summary")
        case .getPromotions(let programName):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/GetMemberPromotions")
        case .enrollInPromotion(let programName):
            return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/EnrollInPromotion")
		case .unenrollPromotion(let programName):
			return ForceConfig.path(for: "connect/loyalty/programs/\(programName)/program-processes/OptOutPromotion")
		case .getVouchers(let programName, let membershipNumber):
				return ForceConfig.path(for: "loyalty/programs/\(programName)/members/\(membershipNumber)/vouchers")
        }
    
    }
    
    /// Get Member Benefits - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    /// - Returns: An ``BenefitModel`` array
    public func getMemberBenefits(for memberId: String, devMode: Bool = false) async throws -> [BenefitModel] {
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: Benefits.self, file: "Benefits")
                return result.memberBenefits
            }
            let path = getPath(for: .getMemberBenefits(memberId: memberId))
            let request = try ForceRequest.create(method: "GET", path: path)
            let result = try await ForceClient.shared.fetch(type: Benefits.self, with: request)
            return result.memberBenefits
        } catch {
            throw error
        }
    }
    
    /// Use public func SOQL<T: Decodable>(type: T.Type, for query: String) async throws -> QueryResult<T>
    public func getBenefit(by benefitIds: [String]) async throws -> [LoyaltyQueryModels.Benefit] {
        do {
            let ids = benefitIds.map { "'" + $0 + "'" }.joined(separator: ",")
            let query = "SELECT Id, Description FROM Benefit WHERE Id in ('\(ids)')"
            let queryResult = try await ForceClient.shared.SOQL(type: LoyaltyQueryModels.Benefit.self, for: query)
            return queryResult.records
        } catch {
            throw error
        }
    }

    /// Use public func SOQL(for query: String) async throws -> QueryResult<Record>
    public func getBenefitRecord(by benefitIds: [String]) async throws -> [Record] {
        do {
            let ids = benefitIds.map { "'" + $0 + "'" }.joined(separator: ",")
            let query = "SELECT Id, Description FROM Benefit WHERE Id in (\(ids))"
            let queryResult = try await ForceClient.shared.SOQL(for: query)
            return queryResult.records
        } catch {
            throw error
        }
    }
    
    /// Get Member Profile - Makes an asynchronous request for data from the Salesforce
    /// - Parameters:
    ///   - for memberId: The member who has these benefits
    ///   - programName: The loytalty program name
    /// - Returns: An ``ProfileModel`` instance
    public func getMemberProfile(for memberId: String, devMode: Bool = false) async throws -> ProfileModel {
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: ProfileModel.self, file: "Profile")
                return result
            }
            let path = getPath(for: .getMemberProfile(programName: loyaltyProgramName))
            let queryItems = ["memberId": "\(memberId)"]
            let request = try ForceRequest.create(method: "GET", path: path, queryItems: queryItems)
            return try await ForceClient.shared.fetch(type: ProfileModel.self, with: request)
        } catch {
            throw error
        }
    }
    
    private func randomString(of length: Int) -> String {
         let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         var s = ""
         for _ in 0 ..< length {
             s.append(letters.randomElement()!)
         }
         return s
    }
    
    public func postEnrollment(firstName: String, lastName: String, email: String, phone: String, emailNotification: Bool) async throws -> EnrollmentOutputModel {
        
        let currentDate = Date()
        let membershipNumber = randomString(of: 8)
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
            let path = getPath(for: .individualEnrollment(programName: loyaltyProgramName))
            let request = try ForceRequest.create(method: "POST", path: path, body: requestBody)
            return try await ForceClient.shared.fetch(type: EnrollmentOutputModel.self, with: request)
            
        } catch {
            throw error
        }
        
    }
    
    public func enrollIn(promotion promotionName: String, for membershipNumber: String) async throws {
        let body = [
            "processParameters": [
                [
                    "MembershipNumber": membershipNumber,
                    "PromotionName": promotionName
                ]
            ]
        ]
        
        do {
            let path = getPath(for: .enrollInPromotion(programName: loyaltyProgramName))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(method: "POST", path: path, body: bodyJsonData)
            let _ = try await ForceClient.shared.fetch(type: EnrollPromotionOutputModel.self, with: request)
        } catch {
            throw error
        }
    }
	
	public final func unenroll(promotionId: String, for membershipNumber: String, devMode: Bool = false) async throws {
		let body = [
			"processParameters": [
				[
					"MembershipNumber": membershipNumber,
					"PromotionId": promotionId
				]
			]
		]
		try await unenroll(requestBody: body, devMode: devMode)
	}
	
	public final func unenroll(promotionName: String, for membershipNumber: String, devMode: Bool = false) async throws {
		let body = [
			"processParameters": [
				[
					"MembershipNumber": membershipNumber,
					"PromotionName": promotionName
				]
			]
		]
		try await unenroll(requestBody: body, devMode: devMode)
	}
    
	private func unenroll(requestBody: [String: Any], devMode: Bool = false) async throws {
		if devMode {
			let _ = try ForceClient.shared.fetchLocalJson(type: UnenrollPromotionResponseModel.self, file: "UnenrollPromotion")
			return
		}
		
		do {
			let path = getPath(for: .unenrollPromotion(programName: loyaltyProgramName))
			let bodyJsonData = try JSONSerialization.data(withJSONObject: requestBody)
			let request = try ForceRequest.create(method: "POST", path: path, body: bodyJsonData)
			let response = try await ForceClient.shared.fetch(type: UnenrollPromotionResponseModel.self, with: request)
			if !response.status {
				throw ForceError.requestFailed(description: response.message ?? "Unknown")
			}
		} catch {
			throw error
		}
	}
	
    public func getPromotions(memberId: String, devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MemberId": memberId]
            ]
        ]
        return try await getPromotions(requsetBody: body, devMode: devMode)
    }
    
    public func getPromotions(membershipNumber: String, devMode: Bool = false) async throws -> PromotionModel {
        let body: [String: Any] = [
            "processParameters": [
                ["MembershipNumber": membershipNumber]
            ]
        ]
        return try await getPromotions(requsetBody: body, devMode: devMode)
    }
    
    private func getPromotions(requsetBody: [String: Any], devMode: Bool = false) async throws -> PromotionModel {
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: PromotionModel.self, file: "Promotions")
                return result
            }
            let path = getPath(for: .getPromotions(programName: loyaltyProgramName))
            let bodyJsonData = try JSONSerialization.data(withJSONObject: requsetBody)
            let request = try ForceRequest.create(method: "POST", path: path, body: bodyJsonData)
            let result = try await ForceClient.shared.fetch(type: PromotionModel.self, with: request)
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
    public func getTransactions(for membershipNumber: String, pageNumber: Int? = nil, journalTypeName: String? = nil, journalSubTypeName: String? = nil, periodStartDate: String? = nil, periodEndDate: String? = nil,  devMode: Bool = false) async throws -> [TransactionJournal] {
        let pageNumberString = pageNumber == nil ? nil : String(describing: pageNumber)
        let queryItems = ["pageNumber": pageNumberString,
                          "journalTypeName": journalTypeName,
                          "journalSubTypeName": journalSubTypeName,
                          "periodStartDate": periodStartDate,
                          "periodEndDate": periodEndDate ].compactMapValues { $0 }
        
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: TransactionModel.self, file: "Transactions")
                return result.transactionJournals
            }
            let path = getPath(for: .getTransactionHistory(programName: loyaltyProgramName, memberId: membershipNumber))
            let request = try ForceRequest.create(method: "GET", path: path, queryItems: queryItems)
            let result = try await ForceClient.shared.fetch(type: TransactionModel.self, with: request)
            return result.transactionJournals
        } catch {
            throw error
        }
    }
    
    /// Use public func SOQL(for query: String) async throws -> QueryResult<Record>
    public func getVoucherRecords(membershipNumber: String, devMode: Bool = false) async throws -> [LoyaltyQueryModels.Voucher] {
        do {
            if devMode {
                let result = try ForceClient.shared.fetchLocalJson(type: LoyaltyQueryModels.VoucherRecode.self, file: "Vouchers")
                return result.records
            }
            let query = "SELECT VoucherDefinition.Name, Voucher.Image__c, VoucherDefinition.Description, VoucherDefinition.Type, VoucherDefinition.FaceValue, VoucherDefinition.DiscountPercent, VoucherCode, ExpirationDate, Id, Status FROM Voucher WHERE LoyaltyProgramMember.MembershipNumber = '\(membershipNumber)'"
            let queryResult = try await ForceClient.shared.SOQL(type: LoyaltyQueryModels.Voucher.self, for: query)
            return queryResult.records
        } catch {
            throw error
        }
    }
	
	public func getVouchers(
		membershipNumber: String,
		devMode: Bool = false,
		voucherStatus: [VoucherStatus]? = nil,
		pageNumber: Int? = nil,
		productId: [String]? = nil,
		productCategoryId: [String]? = nil,
		productName: [String]? = nil,
		productCategoryName: [String]? = nil,
		sortBy: SortBy? = nil,
		sortOrder: SortOrder? = nil
	) async throws -> [VoucherModel] {
		do {
			if devMode {
				let result = try ForceClient.shared.fetchLocalJson(type: VouchersResponse.self, file: "GetVouchers")
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
			let path = getPath(for: .getVouchers(programName: loyaltyProgramName, membershipNumber: membershipNumber))
			let request = try ForceRequest.create(method: "GET", path: path, queryItems: queries)
			let result = try await ForceClient.shared.fetch(type: VouchersResponse.self, with: request)
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
