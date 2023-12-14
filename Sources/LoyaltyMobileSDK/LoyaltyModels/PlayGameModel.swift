//
//  PlayGameModel.swift
//  
//
//  Created by Damodaram Nandi on 21/11/23.
//

import Foundation

// MARK: - PlayGameModel
public struct PlayGameModel: Codable {
    public let message: String?
    public let status: Bool
    public let gameReward: [PlayGameReward]
}

// MARK: - PlayGameReward
public struct PlayGameReward: Codable {
    public let name, rewardType: String
    public let color, description,rewardDefinitionId,gameRewardId: String?
    public let expirationDate: Date?
    public let rewardValue, imageUrl, issuedRewardReference: String?
}
