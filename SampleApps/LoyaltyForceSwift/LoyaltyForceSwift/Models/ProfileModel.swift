//
//  ProfileModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

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
    let additionalLoyaltyProgramMemberFields: [String: Bool?]
    let associatedAccount: AssociatedAccount?
    let associatedContact: AssociatedContact
    let canReceivePartnerPromotions, canReceivePromotions: Bool
    let enrollmentChannel, enrollmentDate: String
    let groupCreatedByMember, groupName, lastActivityDate: String?
    let loyaltyProgramMemberID, loyaltyProgramName: String
    let memberCurrencies: [MemberCurrency]
    let memberStatus: String
    let memberTiers: [MemberTier]
    let memberType, membershipEndDate: String
    let membershipLastRenewalDate: String?
    let membershipNumber: String
    let referredBy, relatedCorporateMembershipNumber: String?
    let transactionJournalStatementFrequency: String
    let transactionJournalStatementLastGeneratedDate: String?
    let transactionJournalStatementMethod: String

    enum CodingKeys: String, CodingKey {
        case additionalLoyaltyProgramMemberFields, associatedAccount, associatedContact, canReceivePartnerPromotions, canReceivePromotions, enrollmentChannel, enrollmentDate, groupCreatedByMember, groupName, lastActivityDate
        case loyaltyProgramMemberID = "loyaltyProgramMemberId"
        case loyaltyProgramName, memberCurrencies, memberStatus, memberTiers, memberType, membershipEndDate, membershipLastRenewalDate, membershipNumber, referredBy, relatedCorporateMembershipNumber, transactionJournalStatementFrequency, transactionJournalStatementLastGeneratedDate, transactionJournalStatementMethod
    }
}

// MARK: - AssociatedAccount
public struct AssociatedAccount: Codable {
}

// MARK: - AssociatedContact
public struct AssociatedContact: Codable {
    let contactID, email, firstName, lastName: String

    enum CodingKeys: String, CodingKey {
        case contactID = "contactId"
        case email, firstName, lastName
    }
}

// MARK: - MemberCurrency
public struct MemberCurrency: Codable {
    let additionalLoyaltyMemberCurrencyFields: AdditionalLoyaltyMemberFields
    let escrowPointsBalance, expirablePoints: Int
    let lastAccrualProcessedDate, lastEscrowProcessedDate, lastExpirationProcessRunDate, lastPointsAggregationDate: String?
    let lastPointsResetDate: String?
    let loyaltyMemberCurrencyName, loyaltyProgramCurrencyID: String
    let loyaltyProgramCurrencyName: String?
    let memberCurrencyID: String
    let nextQualifyingPointsResetDate: String?
    let pointsBalance, qualifyingPointsBalanceBeforeReset, totalEscrowPointsAccrued, totalEscrowRolloverPoints: Int
    let totalPointsAccrued, totalPointsExpired, totalPointsRedeemed: Int

    enum CodingKeys: String, CodingKey {
        case additionalLoyaltyMemberCurrencyFields, escrowPointsBalance, expirablePoints, lastAccrualProcessedDate, lastEscrowProcessedDate, lastExpirationProcessRunDate, lastPointsAggregationDate, lastPointsResetDate, loyaltyMemberCurrencyName
        case loyaltyProgramCurrencyID = "loyaltyProgramCurrencyId"
        case loyaltyProgramCurrencyName
        case memberCurrencyID = "memberCurrencyId"
        case nextQualifyingPointsResetDate, pointsBalance, qualifyingPointsBalanceBeforeReset, totalEscrowPointsAccrued, totalEscrowRolloverPoints, totalPointsAccrued, totalPointsExpired, totalPointsRedeemed
    }
}

// MARK: - AdditionalLoyaltyMemberFields
public struct AdditionalLoyaltyMemberFields: Codable {
}

// MARK: - MemberTier
public struct MemberTier: Codable {
    let additionalLoyaltyMemberTierFields: AdditionalLoyaltyMemberFields
    let areTierBenefitsAssigned: Bool
    let loyaltyMemberTierID, loyaltyMemberTierName: String
    let tierChangeReason, tierChangeReasonType: String?
    let tierEffectiveDate: String
    let tierExpirationDate: String?
    let tierGroupID: String
    let tierGroupName: String?
    let tierID: String
    let tierSequenceNumber: Int

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
