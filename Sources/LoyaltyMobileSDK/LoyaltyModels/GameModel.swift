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
    public let name: String
    public let gameDefinitionId, description: String?
    public let type: GameType
    public let startDate: Date
    public let endDate: Date?
    public let timeoutDuration: Double?
    public let gameRewards: [GameReward]
    public let participantGameRewards: [ParticipantGameReward]
    
    public init(name: String,
                gameDefinitionId: String?,
                description: String?,
                type: GameType,
                startDate: Date,
                endDate: Date?,
                timeoutDuration: Double,
                gameRewards: [GameReward],
                participantGameRewards: [ParticipantGameReward]) {
        self.name = name
        self.gameDefinitionId = gameDefinitionId
        self.description = description
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.timeoutDuration = timeoutDuration
        self.gameRewards = gameRewards
        self.participantGameRewards = participantGameRewards
    }
}

// MARK: - GameReward
public struct GameReward: Codable {
    public let name: String
    public let color: String?
    public let rewardType: RewardType?
    public let rewardValue, imageUrl, description, gameRewardId: String?
}

// MARK: - ParticipantGameReward
public struct ParticipantGameReward: Codable {
    public let gameParticipantRewardID: String
    public let status: RewardStatus
    public let issuedRewardReference, gameRewardId, sourceActivity: String?
    public let expirationDate: Date?

    enum CodingKeys: String, CodingKey {
        case gameParticipantRewardID = "gameParticipantRewardId"
        case expirationDate, issuedRewardReference, status, gameRewardId, sourceActivity
    }
}

// MARK: - GameType
public enum GameType: String, Codable {
    case scratchCard = "Scratchcard"
    case spinaWheel = "SpintheWheel"
}

public enum RewardStatus: String, Codable {
    case yetToReward = "YetToReward"
    case rewarded = "Rewarded"
    case noRewrd = "No Reward"
    case expired
}

public enum RewardType: String, Codable {
    case voucher = "Voucher"
    case loyaltyPoints = "LoyaltyPoints"
    case raffle = "Raffle"
    case noReward = "NoReward"
    case customReward = "CustomReward"
}
