//
//  EnrollmentOutputModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

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
    let contactId: String
    let loyaltyProgramMemberId: String
    let loyaltyProgramName: String
    let membershipNumber: String
    let transactionJournals: [TransactionJournalOutput]
    
}

public struct TransactionJournalOutput: Codable {
    let activityDate: String
    let journalSubType: String
    let journalType: String
    let loyaltyProgram: String
    let loyaltyProgramMember: String
    let referredMember: String?
    let status: String
    let transactionJournalId: String
}
