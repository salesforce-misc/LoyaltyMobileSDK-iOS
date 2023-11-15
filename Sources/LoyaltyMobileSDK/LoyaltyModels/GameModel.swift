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
    public let timeoutDuration: Double
    public let status: GameStatus
    public let gameRewards: [GameReward]
    public let participantGameRewards: [ParticipantGameReward]
    
    public init(name: String, 
                gameDefinitionId: String,
                description: String,
                type: GameType,
                startDate: Date,
                endDate: Date?,
                timeoutDuration: Double,
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
    public let name, description, rewardType, rewardDefinitionId, gameRewardId: String
    public let color: String
    public let expirationDate: Date
    public let rewardValue, imageUrl: String?
}

// MARK: - ParticipantGameReward
public struct ParticipantGameReward: Codable {
    public let gameParticipantRewardID, gameRewardId, sourceActivityId: String
    public let issuedRewardReference, status: String
    public let expirationDate: Date

    enum CodingKeys: String, CodingKey {
        case gameParticipantRewardID = "gameParticipantRewardId"
        case expirationDate, issuedRewardReference, status, gameRewardId, sourceActivityId
    }
}

// MARK: - GameType
public enum GameType: String, Codable {
    case scratchCard
    case spinaWheel = "SpintheWheel"
}

// MARK: - GameStatus
public enum GameStatus: String, Codable {
    case active
    case expired
    case played
}
