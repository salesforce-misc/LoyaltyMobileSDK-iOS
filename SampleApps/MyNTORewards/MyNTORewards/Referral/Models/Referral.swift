//
//  Referral.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/8/24.
//

import Foundation

// MARK: - Referral
struct Referral: Codable {
    let referrerID: String?
    let id, clientEmail, referrerEmail, referralDate: String
    let currentPromotionStage: CurrentPromotionStage

    enum CodingKeys: String, CodingKey {
        case referrerID = "ReferrerId"
        case id = "Id"
        case clientEmail = "ClientEmail"
        case referrerEmail = "ReferrerEmail"
        case referralDate = "ReferralDate"
        case currentPromotionStage = "CurrentPromotionStage"
    }
}
// MARK: - CurrentPromotionStage
struct CurrentPromotionStage: Codable {
    let type: String

    enum CodingKeys: String, CodingKey {
        case type = "Type"
    }
}
