//
//  PromotionModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/20/22.
//

import Foundation

// MARK: - PromotionModel
struct PromotionModel: Codable {
    let message: String?
    let outputParameters: PromotionModelOutputParameters
    let simulationDetails: SimulationDetails
    let status: Bool
}

// MARK: - PromotionModelOutputParameters
struct PromotionModelOutputParameters: Codable {
    let outputParameters: OutputParametersOutputParameters
}

// MARK: - OutputParametersOutputParameters
struct OutputParametersOutputParameters: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let promotionName, fulfillmentAction: String
    let promotionEnrollmentRqr: Bool
    let memberEligibilityCategory: String
    let maximumPromotionRewardValue: Int
    let totalPromotionRewardPointsVal: Int?
    let loyaltyProgramCurrency: String?
    let loyaltyPromotionType, promotionID, startDate, endDate: String
    let resultDescription: String

    enum CodingKeys: String, CodingKey {
        case promotionName, fulfillmentAction, promotionEnrollmentRqr, memberEligibilityCategory, maximumPromotionRewardValue, totalPromotionRewardPointsVal, loyaltyProgramCurrency, loyaltyPromotionType
        case promotionID = "promotionId"
        case startDate, endDate
        case resultDescription = "description"
    }
}

// MARK: - SimulationDetails
struct SimulationDetails: Codable {
}
