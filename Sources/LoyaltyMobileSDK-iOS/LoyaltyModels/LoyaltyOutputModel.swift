//
//  LoyaltyOutputModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/14/22.
//

import Foundation

// MARK: - EnrollPromotionOutputModel
public struct EnrollPromotionOutputModel: Codable {
    let message: String?
    let outputParameters: EnrollPromotionOutputModelOutputParameters
    let simulationDetails: EPSimulationDetails
    let status: Bool
}

// MARK: - EnrollPromotionOutputModelOutputParameters
public struct EnrollPromotionOutputModelOutputParameters: Codable {
    let outputParameters: EPResultsOutputParameters
}

// MARK: - OutputParametersOutputParameters
public struct EPResultsOutputParameters: Codable {
    let results: [EPResult]
}

// MARK: - Result
public struct EPResult: Codable {
    let memberID: String

    enum CodingKeys: String, CodingKey {
        case memberID = "MemberId"
    }
}

// MARK: - SimulationDetails
public struct EPSimulationDetails: Codable {
}


// MARK: - UnenrollPromotionOutPutModel
public struct UnenrollPromotionOutPutModel: Codable {
    let status: String
    let message: String?
}
