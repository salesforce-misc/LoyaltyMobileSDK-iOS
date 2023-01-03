//
//  LoyaltyOutputModel.swift
//  LoyaltyMobileSDK
//
//  Created by Leon Qi on 11/14/22.
//

import Foundation

// MARK: - EnrollPromotionOutputModel
public struct EnrollPromotionOutputModel: Codable {
    public let message: String?
    public let outputParameters: EnrollPromotionOutputModelOutputParameters
    public let simulationDetails: EPSimulationDetails
    public let status: Bool
}

// MARK: - EnrollPromotionOutputModelOutputParameters
public struct EnrollPromotionOutputModelOutputParameters: Codable {
    public let outputParameters: EPResultsOutputParameters
}

// MARK: - OutputParametersOutputParameters
public struct EPResultsOutputParameters: Codable {
    public let results: [EPResult]
}

// MARK: - Result
public struct EPResult: Codable {
    public let memberID: String

    enum CodingKeys: String, CodingKey {
        case memberID = "MemberId"
    }
}

// MARK: - SimulationDetails
public struct EPSimulationDetails: Codable {
}


// MARK: - UnenrollPromotionOutPutModel
public struct UnenrollPromotionOutPutModel: Codable {
    public let status: String
    public let message: String?
}
