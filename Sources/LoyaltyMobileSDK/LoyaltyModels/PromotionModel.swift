/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - PromotionModel
public struct PromotionModel: Codable {
    public let message: String?
    public let outputParameters: PromotionModelOutputParameters
    public let simulationDetails: SimulationDetails
    public let status: Bool
}

// MARK: - WelcomeOutputParameters
public struct PromotionModelOutputParameters: Codable {
    public let outputParameters: PromotionOutputsOutputParameters
}

// MARK: - OutputParametersOutputParameters
public struct PromotionOutputsOutputParameters: Codable {
    public let results: [PromotionResult]
}

// MARK: - Result
public struct PromotionResult: Codable, Identifiable {
    public let fulfillmentAction: String?
    public let promotionEnrollmentRqr: Bool
    public let memberEligibilityCategory: String
    public let promotionImageURL: String?
    public let loyaltyPromotionType: String?
    public let totalPromotionRewardPointsVal: Double?
    public let promotionName, startDate: String
    public let id: String
    public let endDate, loyaltyProgramCurrency, description, promotionEnrollmentEndDate: String?
    public let promEnrollmentStartDate: String?

    enum CodingKeys: String, CodingKey {
        case fulfillmentAction, promotionEnrollmentRqr, memberEligibilityCategory
        case promotionImageURL = "promotionImageUrl"
        case loyaltyPromotionType, totalPromotionRewardPointsVal, promotionName
        case id = "promotionId"
        case startDate, endDate, loyaltyProgramCurrency, description, promotionEnrollmentEndDate, promEnrollmentStartDate
    }
    
    public init(
        fulfillmentAction: String?,
        promotionEnrollmentRqr: Bool,
        memberEligibilityCategory: String,
        promotionImageURL: String?,
        loyaltyPromotionType: String?,
        totalPromotionRewardPointsVal: Double?,
        promotionName: String,
        id: String,
        startDate: String,
        endDate: String?,
        loyaltyProgramCurrency: String?,
        description: String?,
        promotionEnrollmentEndDate: String?,
        promEnrollmentStartDate: String?) {
        self.fulfillmentAction = fulfillmentAction
        self.promotionEnrollmentRqr = promotionEnrollmentRqr
        self.memberEligibilityCategory = memberEligibilityCategory
        self.promotionImageURL = promotionImageURL
        self.loyaltyPromotionType = loyaltyPromotionType
        self.totalPromotionRewardPointsVal = totalPromotionRewardPointsVal
        self.promotionName = promotionName
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.loyaltyProgramCurrency = loyaltyProgramCurrency
        self.description = description
        self.promotionEnrollmentEndDate = promotionEnrollmentEndDate
        self.promEnrollmentStartDate = promEnrollmentStartDate
    }
}

// MARK: - SimulationDetails
public struct SimulationDetails: Codable {
}
