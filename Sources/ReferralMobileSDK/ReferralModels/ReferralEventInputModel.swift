/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ReferralEventInputModel
struct ReferralEventInputModel: Codable {
    public let referralCode, contactID: String
    public let firstName, lastName: String?
    public let email, joiningDate, eventType, productID: String
    public let purchaseAmount: Double
    public let purchaseQuantity: Int
    public let additionalAttributes: AdditionalAttributes
    public let transactionJournalAdditionalAttributes: TransactionJournalAdditionalAttributes
    public let orderReferenceID: String

    enum CodingKeys: String, CodingKey {
        case referralCode
        case contactID = "contactId"
        case firstName, lastName, email, joiningDate, eventType
        case productID = "productId"
        case purchaseAmount, purchaseQuantity, additionalAttributes, transactionJournalAdditionalAttributes
        case orderReferenceID = "orderReferenceId"
    }
}

// MARK: - AdditionalAttributes
public struct AdditionalAttributes: Codable {
    public let attributes: Attributes
}

// MARK: - Attributes
public struct Attributes: Codable {
    public let phoneNumber: String
    public let emailOptOut: Bool
}

// MARK: - TransactionJournalAdditionalAttributes
public struct TransactionJournalAdditionalAttributes: Codable {
}
