//
//  Referral.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/8/24.
//

import Foundation

// MARK: - Referral
struct Referral: Codable, Identifiable {
    let attributes: RecordAttributes
    let referrerID: String?
    let id: String
    let clientEmail, referrerEmail: String?
    let referralDate: Date
    let currentPromotionStage: CurrentPromotionStage
    let referredParty: ReferredParty

    enum CodingKeys: String, CodingKey {
        case attributes
        case referrerID = "ReferrerId"
        case id = "Id"
        case clientEmail = "ClientEmail"
        case referrerEmail = "ReferrerEmail"
        case referralDate = "ReferralDate"
        case currentPromotionStage = "CurrentPromotionStage"
        case referredParty = "ReferredParty"
    }
}

// MARK: - CurrentPromotionStage
struct CurrentPromotionStage: Codable {
    let attributes: RecordAttributes
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case attributes
        case type = "Type"
    }
}

// MARK: - ReferredParty
struct ReferredParty: Codable {
    let attributes: RecordAttributes
    let account: Account
    
    enum CodingKeys: String, CodingKey {
        case attributes
        case account = "Account"
    }
}

// MARK: - Account
struct Account: Codable {
    let attributes: RecordAttributes
    let personEmail: String
    
    enum CodingKeys: String, CodingKey {
        case attributes
        case personEmail = "PersonEmail"
    }
}

struct RecordAttributes: Codable {
    let type: String
    let url: String
}
