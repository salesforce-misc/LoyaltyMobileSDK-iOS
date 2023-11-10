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
    public let name, gameDefinitionId, description: String
    public let type: GameType
    public let startDate: Date
    public let endDate: Date?
    public let timeoutDuration: String
    public let status: GameStatus
    public let gameRewards: [GameReward]
    public let participantGameRewards: [ParticipantGameReward]
    
    public init(name: String, 
                gameDefinitionId: String,
                description: String,
                type: GameType,
                startDate: Date,
                endDate: Date?,
                timeoutDuration: String,
                status: GameStatus,
                gameRewards: [GameReward],
                participantGameRewards: [ParticipantGameReward]) {
        self.name = name
        self.gameDefinitionId = gameDefinitionId
        self.description = description
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.timeoutDuration = timeoutDuration
        self.status = status
        self.gameRewards = gameRewards
        self.participantGameRewards = participantGameRewards
    }
}

// MARK: - GameReward
public struct GameReward: Codable {
    public let name, description, rewardType, rewardDefinition: String
    public let rewardValue, color, imageUrl: String
    public let expirationDate: Date
}

// MARK: - ParticipantGameReward
public struct ParticipantGameReward: Codable {
    public let gameParticipantRewardID, name, description, rewardType: String
    public let rewardDefinitionId, rewardValue, issuedRewardReference, status: String
    public let expirationDate: Date

    enum CodingKeys: String, CodingKey {
        case gameParticipantRewardID = "gameParticipantRewardId"
        case name, description, rewardType, rewardDefinitionId, rewardValue, expirationDate, issuedRewardReference, status
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
