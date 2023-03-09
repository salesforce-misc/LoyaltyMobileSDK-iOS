/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - TransactionModel
public struct TransactionModel: Codable {
    public let message: String?
    public let status: Bool
    public let transactionJournalCount: Int
    public let externalTransactionNumber: String?
    public let transactionJournals: [TransactionJournal]
    
    public init(message: String?, status: Bool, transactionJournalCount: Int, externalTransactionNumber: String, transactionJournals: [TransactionJournal]) {
        self.message = message
        self.status = status
        self.transactionJournalCount = transactionJournalCount
        self.externalTransactionNumber = externalTransactionNumber
        self.transactionJournals = transactionJournals
    }
}

// MARK: - TransactionJournal
public struct TransactionJournal: Codable, Identifiable {
    public let activityDate: String
    public let additionalTransactionJournalAttributes: [additionalTransactionJournalAttribute]
    public let journalTypeName: String
    public let journalSubTypeName: String?
    public let pointsChange: [PointsChange]
    public let id: String
    public let transactionJournalNumber: String?
    public let productCategoryName, productName, transactionAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case activityDate, additionalTransactionJournalAttributes, journalSubTypeName, journalTypeName, pointsChange, transactionJournalNumber
        case id = "transactionJournalId"
        case productCategoryName, productName, transactionAmount
    }
    
    public init(activityDate: String, additionalTransactionJournalAttributes: [additionalTransactionJournalAttribute], journalSubTypeName: String?, journalTypeName: String, pointsChange: [PointsChange], id: String, transactionJournalNumber: String?, productCategoryName: String?, productName: String?, transactionAmount: String?) {
        self.activityDate = activityDate
        self.additionalTransactionJournalAttributes = additionalTransactionJournalAttributes
        self.journalSubTypeName = journalSubTypeName
        self.journalTypeName = journalTypeName
        self.pointsChange = pointsChange
        self.id = id
        self.transactionJournalNumber = transactionJournalNumber
        self.productCategoryName = productCategoryName
        self.productName = productName
        self.transactionAmount = transactionAmount
    }
}

// MARK: - AdditionalAttribute
public struct additionalTransactionJournalAttribute: Codable {
    public let fieldName, value: String
    
    public init(fieldName: String, value: String) {
        self.fieldName = fieldName
        self.value = value
    }
}

// MARK: - PointsChange
public struct PointsChange: Codable {
    public let changeInPoints: Double
    public let loyaltyMemberCurrency: String
    
    public init(changeInPoints: Double, loyaltyMemberCurrency: String) {
        self.changeInPoints = changeInPoints
        self.loyaltyMemberCurrency = loyaltyMemberCurrency
    }
}
