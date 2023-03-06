/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/* Response - Sample output

 {
     "contactId": "0034x00001ITEYf",
     "loyaltyProgramMemberId": "0lM4x000000LOkB",
     "loyaltyProgramName": "NTO Insider",
     "membershipNumber": "Test001",
     "transactionJournals": [
         {
             "activityDate": "2022-01-01T08:00:00.000Z",
             "journalSubType": "Member Enrollment",
             "journalType": "Accrual",
             "loyaltyProgram": "NTO Insider",
             "loyaltyProgramMember": "Test001",
             "referredMember": null,
             "status": "Pending",
             "transactionJournalId": "0lV4x000000CbwX"
         }
     ]
 }
 
 */

public struct EnrollmentOutputModel: Codable {
    public let contactId: String
    public let loyaltyProgramMemberId: String
    public let loyaltyProgramName: String
    public let membershipNumber: String
    public let transactionJournals: [TransactionJournalOutput]
    
}

public struct TransactionJournalOutput: Codable {
    public let activityDate: String
    public let journalSubType: String
    public let journalType: String
    public let loyaltyProgram: String
    public let loyaltyProgramMember: String
    public let referredMember: String?
    public let status: String
    public let transactionJournalId: String
}
