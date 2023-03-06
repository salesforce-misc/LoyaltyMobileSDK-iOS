/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - TransactionModel
public struct TransactionModel: Codable {
    public let status, programName, membershipNumber: String
    public let recordCount: Int
    public let transactionHistory: [TransactionHistory]
}

// MARK: - TransactionHistory
public struct TransactionHistory: Codable, Identifiable {
    public let id: String
    public let transactionAmount: Double?
    public let productDetails: ProductDetails?
    public let memberCurrency: [TransactionCurrency]
    public let activityDate, activity: String
    
    public init(id: String, transactionAmount: Double?, productDetails: ProductDetails?, memberCurrency: [TransactionCurrency], activityDate: String, activity: String) {
        self.id = id
        self.transactionAmount = transactionAmount
        self.productDetails = productDetails
        self.memberCurrency = memberCurrency
        self.activityDate = activityDate
        self.activity = activity
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "transactionId"
        case transactionAmount, productDetails, memberCurrency, activityDate, activity
    }

}

// MARK: - MemberCurrency
public struct TransactionCurrency: Codable {
    public let value: Double
    public let name: String
    
    public init(value: Double, name: String) {
        self.value = value
        self.name = name
    }
}

// MARK: - ProductDetails
public struct ProductDetails: Codable {
    public let productCategory, product: String?
    public let partner: String?
}
