//
//  SOQLManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 21/09/23.
//

import Foundation
import LoyaltyMobileSDK

final class SOQLManager {
	static let namespace = "ReceiptScanner"
	private let forceClient: ForceClient
	private let receiptsRecordName = "\(namespace)__Receipts__c"
	init(forceClient: ForceClient) {
		self.forceClient = forceClient
	}
	
	func getReceipts(membershipNumber: String) async throws -> [Receipt] {
		let queryFields = ["Id",
						   "\(Self.namespace)__PurchaseDate__c",
						   "\(Self.namespace)__ReceiptID__c",
						   "Name",
						   "\(Self.namespace)__Status__c",
						   "\(Self.namespace)__StoreName__c",
						   "\(Self.namespace)__TotalRewardPoints__c",
						   "CreatedDate",
						   "\(Self.namespace)__TotalAmount__c",
						   "\(Self.namespace)__ImageUrl__c",
						   "\(Self.namespace)__APIResponse__c",
						   "\(Self.namespace)__ReceiptCurrency__c",
						   "\(Self.namespace)__Comments__c"]
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
						   "\(Self.namespace)__PurchaseDate__c",
						   "\(Self.namespace)__ReceiptID__c",
						   "Name",
						   "\(Self.namespace)__Status__c",
						   "\(Self.namespace)__StoreName__c",
						   "\(Self.namespace)__TotalRewardPoints__c",
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
