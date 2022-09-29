//
//  EnrollmentModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/27/22.
//

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
    let enrollmentDate: Date
    let membershipNumber: String
    let associatedContactDetails: AssociatedContactDetails
    let memberStatus: String
    let referredBy: String?
    let createTransactionJournals: Bool?
    let transactionJournalStatementFrequency, transactionJournalStatementMethod: String?
    let enrollmentChannel: String?
    let canReceivePromotions, canReceivePartnerPromotions: Bool?
    let membershipEndDate: String?
    let relatedCorporate​MembershipNumber: String?
    let additionalMemberFieldValues: AdditionalFieldValues
}

// MARK: - AdditionalFieldValues
public struct AdditionalFieldValues: Codable {
    let attributes: [String: String]
}

// MARK: - AssociatedContactDetails
public struct AssociatedContactDetails: Codable {
    let firstName: String?
    let lastName: String
    let email: String?
    let allowDuplicateRecords: Bool?
    let additionalContactFieldValues: AdditionalFieldValues
}

