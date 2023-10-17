//
//  GamesResponseModel.swift
//
//
//  Created by Damodaram Nandi on 16/10/23.
//

import Foundation

// To do Need to work on initialization of model
// MARK: - GamesResponseModel
public struct GamesResponseModel: Codable {
    public let errorMessage: String?
    public let status: Bool
    public let gameDefinitions: [GameDefinition]
}

// MARK: - GameDefinition
public struct GameDefinition: Codable {
    public let name, description, startDate, definitionId: String
    public let endDate, timeoutDuration: String
    public let status: GameStatus
    public let type: GameType
    public let gameRewards: GameRewards
}

// MARK: - GameRewards
public struct GameRewards: Codable {
    public let gameRewardReceived, gameRewardAvailable, gameRewardExpired: [GameReward]
}

// MARK: - GameReward
public struct GameReward: Codable {
    public let name, description, rewardType, rewardDefinitionID: String
    public let rewardValue, color, imageURL, expirationDate: String

    enum CodingKeys: String, CodingKey {
        case name, description, rewardType, rewardDefinitionID, rewardValue, color
        case imageURL = "imageUrl"
        case expirationDate
    }
}

// MARK: - GameType
public enum GameType: String, Codable {
    case scratchCard
    case spinaWheel
}

// MARK: - GameStatus
public enum GameStatus: String, Codable {
    case active
    case expired
    case played
}
