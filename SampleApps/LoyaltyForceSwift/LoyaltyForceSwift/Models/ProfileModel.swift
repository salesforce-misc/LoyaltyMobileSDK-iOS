//
//  ProfileModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

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
