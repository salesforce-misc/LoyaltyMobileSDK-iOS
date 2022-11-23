//
//  PromotionModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/20/22.
//

import Foundation

// MARK: - PromotionModel
public struct PromotionModel: Codable {
    let message: String?
    let outputParameters: PromotionModelOutputParameters
    let simulationDetails: SimulationDetails
    let status: Bool
}

// MARK: - PromotionModelOutputParameters
public struct PromotionModelOutputParameters: Codable {
    let outputParameters: PromotionOutputsOutputParameters
}

// MARK: - OutputParametersOutputParameters
public struct PromotionOutputsOutputParameters: Codable {
    let results: [PromotionResult]
}

// MARK: - Result
public struct PromotionResult: Codable, Identifiable {
    public let id: String
    let loyaltyPromotionType: String?
    let maximumPromotionRewardValue, totalPromotionRewardPointsVal: Int?
    let loyaltyProgramCurrency: String?
    let memberEligibilityCategory: String
    let promotionEnrollmentRqr: Bool
    let fulfillmentAction: String?
    let promotionName: String
    let startDate: String
    let endDate: String?
    let description: String?
    let promEnrollmentStartDate, promotionEnrollmentEndDate: String?
    let imageName: String?

    enum CodingKeys: String, CodingKey {
        case loyaltyPromotionType, maximumPromotionRewardValue, totalPromotionRewardPointsVal, loyaltyProgramCurrency, memberEligibilityCategory, promotionEnrollmentRqr, fulfillmentAction, promotionName
        case id = "promotionId"
        case startDate, endDate
        case description, promEnrollmentStartDate, promotionEnrollmentEndDate
        case imageName = "Image__c"
    }
}

// MARK: - SimulationDetails
public struct SimulationDetails: Codable {
}
