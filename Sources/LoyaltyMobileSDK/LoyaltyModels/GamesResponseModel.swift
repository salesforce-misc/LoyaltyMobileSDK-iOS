//
//  GamesResponseModel.swift
//
//
//  Created by Damodaram Nandi on 16/10/23.
//

import Foundation

// MARK: - GameModel
public struct GameModel: Codable {
    public let message: String?
    public let status: Bool
    public let gameDefinitions: [GameDefinition]
}

// MARK: - GameDefinition
public struct GameDefinition: Codable {
    public let name, definitionID, description: String
    public let type: GameType
    public let startDate, endDate: Date
    public let timeoutDuration: String
    public let status: GameStatus
    public let eligibleRewards: [GameReward]
    public let wonRewards: [GameWinningReward]

    enum CodingKeys: String, CodingKey {
        case name
        case definitionID = "definitionId"
        case description, type, startDate, endDate, timeoutDuration, status, eligibleRewards, wonRewards
    }
}

// MARK: - GameReward
public struct GameReward: Codable {
    public let name, description, rewardType, rewardDefinition: String
    public let rewardValue, color, image: String
}

// MARK: - GameWinningReward
public struct GameWinningReward: Codable {
    public let gameParticipantRewardID, name, description, rewardType: String
    public let rewardDefinition, rewardValue, expirationDate, issuedRewardReference: String
    public let status: String

    enum CodingKeys: String, CodingKey {
        case gameParticipantRewardID = "gameParticipantRewardId"
        case name, description, rewardType, rewardDefinition, rewardValue, expirationDate, issuedRewardReference, status
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
