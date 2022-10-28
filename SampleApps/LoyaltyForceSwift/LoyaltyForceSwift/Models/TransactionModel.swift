//
//  TransactionModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/20/22.
//

import Foundation

// MARK: - TransactionModel
struct TransactionModel: Codable {
    let message: String?
    let status: Bool
    let totalCount: Int
    let transactionJournals: [TransactionJournal]
}

// MARK: - TransactionJournal
struct TransactionJournal: Codable {
    let status, lastModifiedDate: String
    let isDeleted: Bool
    let journalTypeID, journalDate, activityDate, usageType: String
    let name, systemModstamp, memberID, journalSubTypeID: String
    let createdByID, createdDate, id, lastModifiedByID: String
    let loyaltyProgramID: String

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case lastModifiedDate = "LastModifiedDate"
        case isDeleted = "IsDeleted"
        case journalTypeID = "JournalTypeId"
        case journalDate = "JournalDate"
        case activityDate = "ActivityDate"
        case usageType = "UsageType"
        case name = "Name"
        case systemModstamp = "SystemModstamp"
        case memberID = "MemberId"
        case journalSubTypeID = "JournalSubTypeId"
        case createdByID = "CreatedById"
        case createdDate = "CreatedDate"
        case id = "Id"
        case lastModifiedByID = "LastModifiedById"
        case loyaltyProgramID = "LoyaltyProgramId"
    }
}
