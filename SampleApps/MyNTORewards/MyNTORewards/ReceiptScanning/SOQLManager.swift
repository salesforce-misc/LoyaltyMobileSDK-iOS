//
//  SOQLManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 21/09/23.
//

import Foundation
import LoyaltyMobileSDK

final class SOQLManager {
	private let forceClient: ForceClient
	private let receiptsRecordName = "\(StringConstants.Receipts.namespace)__Receipts__c"
	private let loyaltyProgramMemberBadge = "LoyaltyProgramMemberBadge"
	private let loyaltyProgramBadge = "LoyaltyProgramBadge"
	
	init(forceClient: ForceClient) {
		self.forceClient = forceClient
	}
	
	func getReceipts(membershipNumber: String) async throws -> [Receipt] {
		let queryFields = ["Id",
						   "\(StringConstants.Receipts.namespace)__PurchaseDate__c",
						   "\(StringConstants.Receipts.namespace)__ReceiptID__c",
						   "Name",
						   "\(StringConstants.Receipts.namespace)__Status__c",
						   "\(StringConstants.Receipts.namespace)__StoreName__c",
						   "\(StringConstants.Receipts.namespace)__TotalRewardPoints__c",
						   "CreatedDate",
						   "\(StringConstants.Receipts.namespace)__TotalAmount__c",
						   "\(StringConstants.Receipts.namespace)__ImageUrl__c",
						   "\(StringConstants.Receipts.namespace)__APIResponse__c",
						   "\(StringConstants.Receipts.namespace)__ReceiptCurrency__c",
						   "\(StringConstants.Receipts.namespace)__Comments__c"]
		let whereClause = "\(StringConstants.Receipts.namespace)__LoyaltyProgramMember__r.MembershipNumber"
		let orderByField = "CreatedDate"
		let sortOrder = SortOrder.DESC
		let operation = "SELECT \(queryFields.joined(separator: ","))"
		let target = "FROM \(receiptsRecordName) "
		let condition = "WHERE \(whereClause) = '\(membershipNumber)' ORDER BY \(orderByField) \(sortOrder.rawValue)"
		let query = "\(operation) \(target) \(condition)"
		
		do {
			let queryResult = try await forceClient.SOQL(type: Receipt.self, for: query)
			return queryResult.records
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
	
	func getReceipt(membershipNumber: String, id: String) async throws -> Receipt? {
		let queryFields = ["Id",
						   "\(StringConstants.Receipts.namespace)__PurchaseDate__c",
						   "\(StringConstants.Receipts.namespace)__ReceiptID__c",
						   "Name",
						   "\(StringConstants.Receipts.namespace)__Status__c",
						   "\(StringConstants.Receipts.namespace)__StoreName__c",
						   "\(StringConstants.Receipts.namespace)__TotalRewardPoints__c",
						   "CreatedDate"]
		let whereClauseMembershipNumber = "\(StringConstants.Receipts.namespace)__LoyaltyProgramMember__r.MembershipNumber"
		let whereClauseId = "Id"
		let operation = "SELECT \(queryFields.joined(separator: ","))"
		let target = "FROM \(receiptsRecordName)"
		let condition = "WHERE \(whereClauseMembershipNumber) = '\(membershipNumber)' AND \(whereClauseId) = '\(id)'"
		let query = "\(operation) \(target) \(condition)"
		
		do {
			let queryResult = try await forceClient.SOQL(type: Receipt.self, for: query)
			return queryResult.records.first
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
	
	func getProgramMemberBadges(devMode: Bool = false, mockFileName: String, memberId: String) async throws -> [LoyaltyProgramMemberBadge] {
		if devMode {
			let result = try fetchLocalJson(type: [LoyaltyProgramMemberBadge].self, file: mockFileName)
			return result
		}
		let queryFields = ["Name",
						   "StartDate",
						   "EndDate",
						   "Reason",
						   "Status",
						   "LoyaltyProgramMemberId",
						   "LoyaltyProgramBadgeId"]
		let operation = "SELECT \(queryFields.joined(separator: ","))"
		let target = "FROM \(loyaltyProgramMemberBadge)"
		let whereClause = "LoyaltyProgramMemberId"
		let condition = "WHERE \(whereClause) = '\(memberId)'"
		let query = "\(operation) \(target) \(condition)"
		
		do {
			let queryResult = try await forceClient.SOQL(type: LoyaltyProgramMemberBadge.self, for: query)
			return queryResult.records
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
	
	func getProgramBadges(devMode: Bool = false, mockFileName: String) async throws -> [LoyaltyProgramBadge] {
		if devMode {
			let result = try fetchLocalJson(type: [LoyaltyProgramBadge].self, file: mockFileName)
			return result
		}
		let queryFields = ["Id",
						   "Description",
						   "ImageUrl",
						   "LoyaltyProgramId",
						   "Name",
						   "StartDate",
						   "Status",
						   "ValidityDuration",
						   "ValidityDurationUnit",
						   "ValidityEndDate",
						   "ValidityType"
		]
		let operation = "SELECT \(queryFields.joined(separator: ","))"
		let target = "FROM \(loyaltyProgramBadge)"
		let query = "\(operation) \(target)"
		
		do {
			let queryResult = try await forceClient.SOQL(type: LoyaltyProgramBadge.self, for: query)
			return queryResult.records
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
	
	private func fetchLocalJson<T: Decodable>(type: T.Type, file: String, bundle: Bundle = Bundle.publicModule) throws -> T {
		
		guard let fileURL = bundle.url(forResource: file, withExtension: "json") else {
			throw URLError(.badURL, userInfo: [NSURLErrorFailingURLStringErrorKey: "\(file).json"])
		}
		
		let dateFormatters = DateFormatter.forceFormatters()
		let decoder = JSONDecoder()
		
		decoder.dateDecodingStrategy = .custom { decoder -> Date in
			let container = try decoder.singleValueContainer()
			let dateString = try container.decode(String.self)
			
			for dateFormatter in dateFormatters {
				if let date = dateFormatter.date(from: dateString) {
					return date
				}
			}
			
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "NetworkManager cannot decode date string \(dateString)")
		}
		
		return try decoder.decode(T.self, from: try Data(contentsOf: fileURL))
	}
}
