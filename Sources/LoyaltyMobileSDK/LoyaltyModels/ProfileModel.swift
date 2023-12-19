/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/* Sample response
 {
     "additionalLoyaltyProgramMemberFields": {
         "City__c": null,
         "Age__c": null,
         "Anniversary__c": null,
         "ReferredMemberPromotion__c": null,
         "DateOfBirth__c": null,
         "Hobbies__c": null,
         "Gender__c": null,
         "SeedData__c": false,
         "Income__c": null,
         "State__c": null,
         "B2CRetail_Most_Recent_Survey_Email_Date__c": null
     },
     "associatedAccount": null,
     "associatedContact": {
         "contactId": "0034x00001JdM7nAAF",
         "email": "test106@test.com",
         "firstName": "Test106",
         "lastName": "Test106"
     },
     "canReceivePartnerPromotions": true,
     "canReceivePromotions": true,
     "enrollmentChannel": "Email",
     "enrollmentDate": "2022-10-20",
     "groupCreatedByMember": null,
     "groupName": null,
     "lastActivityDate": null,
     "loyaltyProgramMemberId": "0lM4x000000LOr2EAG",
     "loyaltyProgramName": "NTO Insider",
     "memberCurrencies": [
         {
             "additionalLoyaltyMemberCurrencyFields": {},
             "escrowPointsBalance": 0.0,
             "expirablePoints": 0.0,
             "lastAccrualProcessedDate": null,
             "lastEscrowProcessedDate": null,
             "lastExpirationProcessRunDate": null,
             "lastPointsAggregationDate": null,
             "lastPointsResetDate": null,
             "loyaltyMemberCurrencyName": "Tier Points",
             "loyaltyProgramCurrencyId": "0lc4x000000L1bnAAC",
             "loyaltyProgramCurrencyName": null,
             "memberCurrencyId": "0lz4x000000LNnOAAW",
             "nextQualifyingPointsResetDate": "2023-10-20",
             "pointsBalance": 0.0,
             "qualifyingPointsBalanceBeforeReset": 0.0,
             "totalEscrowPointsAccrued": 0.0,
             "totalEscrowRolloverPoints": 0.0,
             "totalPointsAccrued": 0.0,
             "totalPointsExpired": 0.0,
             "totalPointsRedeemed": 0.0
         },
         {
             "additionalLoyaltyMemberCurrencyFields": {},
             "escrowPointsBalance": 0.0,
             "expirablePoints": 0.0,
             "lastAccrualProcessedDate": null,
             "lastEscrowProcessedDate": null,
             "lastExpirationProcessRunDate": null,
             "lastPointsAggregationDate": null,
             "lastPointsResetDate": null,
             "loyaltyMemberCurrencyName": "Reward Points",
             "loyaltyProgramCurrencyId": "0lc4x000000L1bmAAC",
             "loyaltyProgramCurrencyName": null,
             "memberCurrencyId": "0lz4x000000LNnNAAW",
             "nextQualifyingPointsResetDate": null,
             "pointsBalance": 0.0,
             "qualifyingPointsBalanceBeforeReset": 0.0,
             "totalEscrowPointsAccrued": 0.0,
             "totalEscrowRolloverPoints": 0.0,
             "totalPointsAccrued": 0.0,
             "totalPointsExpired": 0.0,
             "totalPointsRedeemed": 0.0
         }
     ],
     "memberStatus": "Active",
     "memberTiers": [
         {
             "additionalLoyaltyMemberTierFields": {},
             "areTierBenefitsAssigned": false,
             "loyaltyMemberTierId": "0ly4x000000c02lAAA",
             "loyaltyMemberTierName": "Silver",
             "tierChangeReason": null,
             "tierChangeReasonType": null,
             "tierEffectiveDate": "2022-10-20",
             "tierExpirationDate": null,
             "tierGroupId": "0lt4x000000L1bXAAS",
             "tierGroupName": null,
             "tierId": "0lg4x000000L1bmAAC",
             "tierSequenceNumber": 10
         }
     ],
     "memberType": "Individual",
     "membershipEndDate": null,
     "membershipLastRenewalDate": null,
     "membershipNumber": "7UF0JW82",
     "referredBy": null,
     "relatedCorporateMembershipNumber": null,
     "transactionJournalStatementFrequency": "Monthly",
     "transactionJournalStatementLastGeneratedDate": null,
     "transactionJournalStatementMethod": "Mail"
 }
 
 */

import Foundation

// MARK: - ProfileModel
public struct ProfileModel: Codable {
    public let additionalLoyaltyProgramMemberFields: AdditionalLoyaltyProgramMemberFields
    public let associatedAccount: AssociatedAccount?
    public let associatedContact: AssociatedContact?
    public let canReceivePartnerPromotions, canReceivePromotions: Bool
    public let enrollmentChannel, enrollmentDate: String
    public let groupCreatedByMember, groupName, lastActivityDate: String?
    public let loyaltyProgramMemberID, loyaltyProgramName: String
    public let memberCurrencies: [MemberCurrency]
    public let memberStatus: String
    public let memberTiers: [MemberTier]
    public let memberType: String
    public let membershipEndDate: String?
    public let membershipLastRenewalDate: String?
    public let membershipNumber: String
    public let referredBy, relatedCorporateMembershipNumber: String?
    public let transactionJournalStatementFrequency: String
    public let transactionJournalStatementLastGeneratedDate: String?
    public let transactionJournalStatementMethod: String

    enum CodingKeys: String, CodingKey {
        case additionalLoyaltyProgramMemberFields, associatedAccount, associatedContact
        case canReceivePartnerPromotions, canReceivePromotions, enrollmentChannel, enrollmentDate
        case groupCreatedByMember, groupName, lastActivityDate
        case loyaltyProgramMemberID = "loyaltyProgramMemberId"
        case loyaltyProgramName, memberCurrencies, memberStatus, memberTiers, memberType
        case membershipEndDate, membershipLastRenewalDate, membershipNumber, referredBy
        case relatedCorporateMembershipNumber, transactionJournalStatementFrequency
        case transactionJournalStatementLastGeneratedDate, transactionJournalStatementMethod
    }
    
}

// MARK: - AdditionalLoyaltyProgramMemberFields
public struct AdditionalLoyaltyProgramMemberFields: Codable {
    public let cityC: String?
    public let ageC: Double?
    public let anniversaryC, referredMemberPromotionC, dateOfBirthC: String?
    public let hobbiesC, genderC: String?
    public let seedDataC: Bool?
    public let incomeC, stateC, b2CRetailMostRecentSurveyEmailDateC: String?

    enum CodingKeys: String, CodingKey {
        case cityC = "City__c"
        case ageC = "Age__c"
        case anniversaryC = "Anniversary__c"
        case referredMemberPromotionC = "ReferredMemberPromotion__c"
        case dateOfBirthC = "DateOfBirth__c"
        case hobbiesC = "Hobbies__c"
        case genderC = "Gender__c"
        case seedDataC = "SeedData__c"
        case incomeC = "Income__c"
        case stateC = "State__c"
        case b2CRetailMostRecentSurveyEmailDateC = "B2CRetail_Most_Recent_Survey_Email_Date__c"
    }
}

// MARK: - AssociatedAccount
public struct AssociatedAccount: Codable {
}

// MARK: - AssociatedContact
public struct AssociatedContact: Codable {
    public let contactID, firstName, lastName: String
	public let email: String?

    enum CodingKeys: String, CodingKey {
        case contactID = "contactId"
        case email, firstName, lastName
    }
}

// MARK: - MemberCurrency
public struct MemberCurrency: Codable {
    public let additionalLoyaltyMemberCurrencyFields: AdditionalLoyaltyMemberFields
    public let escrowPointsBalance, expirablePoints: Double
    public let lastAccrualProcessedDate: Date?
    public let lastEscrowProcessedDate, lastExpirationProcessRunDate, lastPointsAggregationDate: String?
    public let lastPointsResetDate: String?
    public let loyaltyMemberCurrencyName, loyaltyProgramCurrencyID: String
    public let loyaltyProgramCurrencyName: String?
    public let memberCurrencyID: String
    public let nextQualifyingPointsResetDate: String?
    public let pointsBalance, qualifyingPointsBalanceBeforeReset, totalEscrowPointsAccrued, totalEscrowRolloverPoints: Double
    public let totalPointsAccrued, totalPointsExpired, totalPointsRedeemed: Double

    enum CodingKeys: String, CodingKey {
        case additionalLoyaltyMemberCurrencyFields, escrowPointsBalance, expirablePoints
        case lastAccrualProcessedDate, lastEscrowProcessedDate, lastExpirationProcessRunDate
        case lastPointsAggregationDate, lastPointsResetDate, loyaltyMemberCurrencyName
        case loyaltyProgramCurrencyID = "loyaltyProgramCurrencyId"
        case loyaltyProgramCurrencyName
        case memberCurrencyID = "memberCurrencyId"
        case nextQualifyingPointsResetDate, pointsBalance, qualifyingPointsBalanceBeforeReset
        case totalEscrowPointsAccrued, totalEscrowRolloverPoints, totalPointsAccrued, totalPointsExpired, totalPointsRedeemed
    }
}

// MARK: - AdditionalLoyaltyMemberFields
public struct AdditionalLoyaltyMemberFields: Codable {
}

// MARK: - MemberTier
public struct MemberTier: Codable {
    public let additionalLoyaltyMemberTierFields: AdditionalLoyaltyMemberFields
    public let areTierBenefitsAssigned: Bool
    public let loyaltyMemberTierID, loyaltyMemberTierName: String
    public let tierChangeReason, tierChangeReasonType: String?
    public let tierEffectiveDate: String
    public let tierExpirationDate: String?
    public let tierGroupID: String
    public let tierGroupName: String?
    public let tierID: String
    public let tierSequenceNumber: Int

    enum CodingKeys: String, CodingKey {
        case additionalLoyaltyMemberTierFields, areTierBenefitsAssigned
        case loyaltyMemberTierID = "loyaltyMemberTierId"
        case loyaltyMemberTierName, tierChangeReason, tierChangeReasonType, tierEffectiveDate, tierExpirationDate
        case tierGroupID = "tierGroupId"
        case tierGroupName
        case tierID = "tierId"
        case tierSequenceNumber
    }
}
