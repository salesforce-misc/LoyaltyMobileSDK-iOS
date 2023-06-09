/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/* Request Body - Sample Input
 
 {
   "enrollmentDate" : "2022-01-01T00:00:00",
   "membershipNumber" : "Test001",
   "associatedContactDetails" : {
     "firstName" : "Test001",
     "lastName" : "Test001",
     "email" : "test001@gmail.com",
     "allowDuplicateRecords" : "false",
     "additionalContactFieldValues" : {
       "attributes" : {
              }
     }
   },

   "memberStatus" : "Active",
   "createTransactionJournals" : "true",
   "transactionJournalStatementFrequency" : "Monthly",
   "transactionJournalStatementMethod" : "Mail",
   "enrollmentChannel" : "Email",
   "canReceivePromotions": "true",
   "canReceivePartnerPromotions" : "true",
   "membershipEndDate" : "2023-01-01T00:00:00",
   "additionalMemberFieldValues" : {
     "attributes" : {
       }
   }
 }
 
 */

// MARK: - EnrollmentModel
public struct EnrollmentModel: Codable {
    public let enrollmentDate: Date
    public let membershipNumber: String
    public let associatedContactDetails: AssociatedContactDetails
    public let memberStatus: String
    public let referredBy: String?
    public let createTransactionJournals: Bool?
    public let transactionJournalStatementFrequency, transactionJournalStatementMethod: String?
    public let enrollmentChannel: String?
    public let canReceivePromotions, canReceivePartnerPromotions: Bool?
    public let membershipEndDate: String?
    public let relatedCorporate​MembershipNumber: String?
    public let additionalMemberFieldValues: AdditionalFieldValues
}

// MARK: - AdditionalFieldValues
public struct AdditionalFieldValues: Codable {
    public let attributes: [String: String]
}

// MARK: - AssociatedContactDetails
public struct AssociatedContactDetails: Codable {
    public let firstName: String?
    public let lastName: String
    public let email: String?
    public let allowDuplicateRecords: Bool?
    public let additionalContactFieldValues: AdditionalFieldValues
}
