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
}
