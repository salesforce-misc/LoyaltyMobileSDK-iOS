/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

// MARK: - UnenrollPromotionOutputModel
public struct UnenrollPromotionOutputModel: Codable {
    public let status: String
    public let message: String?
}

public struct UnenrollPromotionResponseModel: Codable {
    public let outputParameters: OutputParameterMain?
    public let status: Bool
    public let message: String?
    public let simulationDetails: SimulationDetails?
}

public struct OutputParameterSub: Codable {
    public let results: [UnenrollPromotionResult]?
}

public struct OutputParameterMain: Codable {
    public let outputParameters: OutputParameterSub?
}

public struct UnenrollPromotionResult: Codable {
    public let LoyaltyProgramMbrPromotionId: String?
}
