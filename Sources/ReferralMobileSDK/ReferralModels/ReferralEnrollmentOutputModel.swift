/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - ReferralEnrollmentOutputModel
public struct ReferralEnrollmentOutputModel: Codable {
    let contactID, memberID, membershipNumber, programName: String
    let promotionReferralCode: String
    let transactionJournals: [EnrollmentTransactionJournal]

    enum CodingKeys: String, CodingKey {
        case contactID = "contactId"
        case memberID = "memberId"
        case membershipNumber, programName, promotionReferralCode, transactionJournals
    }
}

// MARK: - EnrollmentTransactionJournal
public struct EnrollmentTransactionJournal: Codable {
    let activityDate, journalSubType, journalType, membershipNumber: String
    let programName, status, transactionJournalID: String

    enum CodingKeys: String, CodingKey {
        case activityDate, journalSubType, journalType, membershipNumber, programName, status
        case transactionJournalID = "transactionJournalId"
    }
}
