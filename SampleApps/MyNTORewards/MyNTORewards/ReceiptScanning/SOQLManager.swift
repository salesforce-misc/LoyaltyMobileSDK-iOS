//
//  SOQLManager.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 21/09/23.
//

import Foundation
import LoyaltyMobileSDK

final class SOQLManager {
	let forceClient: ForceClient
	
	init(forceClient: ForceClient) {
		self.forceClient = forceClient
	}
	
	func getReceipts(membershipNumber: String, forced: Bool = false) async throws -> [Receipt] {
		let queryFields = ["Id",
						   "Purchase_Date__c",
						   "ReceiptId__c",
						   "Name",
						   "Status__c",
						   "StoreName__c",
						   "Total_Points__c",
						   "CreatedDate",
						   "TotalAmount__c",
						   "ImageUrl__c",
						   "Processed_AWS_Response__c"]
		let recordName = "Receipts__c"
		let whereClause = "Loyalty_Program_Member__r.MembershipNumber"
		let orderByField = "CreatedDate"
		let sortOrder = SortOrder.DESC
		let query = "SELECT \(queryFields.joined(separator: ",")) FROM \(recordName) WHERE \(whereClause) = '\(membershipNumber)' ORDER BY \(orderByField) \(sortOrder.rawValue)"
		
		do {
			let queryResult = try await forceClient.SOQL(type: Receipt.self, for: query)
			return queryResult.records
		} catch {
			Logger.error(error.localizedDescription)
			throw error
		}
	}
}
