/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - EnrollPromotionOutputModel
public struct EnrollPromotionOutputModel: Codable {
    public let message: String?
    public let outputParameters: EnrollPromotionOutputParameters
    public let simulationDetails: EnrollPromotionSimulationDetails
    public let status: Bool
}

// MARK: - EnrollPromotionResultsOutputParameters
public struct EnrollPromotionOutputParameters: Codable {
    public let outputParameters: EnrollPromotionResultsOutputParameters
}

// MARK: - EnrollPromotionResultsOutputParameters
public struct EnrollPromotionResultsOutputParameters: Codable {
    public let results: [EnrollPromotionResult]
}

// MARK: - EnrollPromotionResult
public struct EnrollPromotionResult: Codable {
    public let memberID: String

    enum CodingKeys: String, CodingKey {
        case memberID = "MemberId"
    }
}

// MARK: - EnrollPromotionSimulationDetails
public struct EnrollPromotionSimulationDetails: Codable {
}
