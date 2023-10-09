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
	private let receiptsRecordName = "Receipts__c"
	init(forceClient: ForceClient) {
		self.forceClient = forceClient
	}
	
	func getReceipts(membershipNumber: String) async throws -> [Receipt] {
		let queryFields = ["Id",
						   "PurchaseDate__c",
						   "ReceiptID__c",
						   "Name",
						   "Status__c",
						   "StoreName__c",
						   "TotalRewardPoints__c",
						   "CreatedDate",
						   "TotalAmount__c",
						   "ImageUrl__c",
						   "APIResponse__c",
						   "ReceiptCurrency__c",
						   "Comments__c"]
		let whereClause = "LoyaltyProgramMember__r.MembershipNumber"
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
						   "PurchaseDate__c",
						   "ReceiptID__c",
						   "Name",
						   "Status__c",
						   "StoreName__c",
						   "TotalRewardPoints__c",
						   "CreatedDate"]
		let whereClauseMembershipNumber = "LoyaltyProgramMember__r.MembershipNumber"
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
}
