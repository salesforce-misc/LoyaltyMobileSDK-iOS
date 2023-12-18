/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

/// A class for managing requests related to loyalty programs using the Referral API.
public class ReferralAPIManager {
    
    /// An instance of `ForceAuthenticator` for authentication
    public var auth: ForceAuthenticator
    
    /// The default version to be used for the loyalty program API requests.
    public static let defaultVersion = "58.0"
    
    /// The base URL of the loyalty program API
    public var instanceURL: String
    
    /// An instance of `ForceClient` to handle API requests
    private var forceClient: ForceClient
    
    /// Initializes a `ReferralAPIManager` with the necessary parameters.
    public init(auth: ForceAuthenticator, instanceURL: String, forceClient: ForceClient) {
        self.auth = auth
        self.instanceURL = instanceURL
        self.forceClient = forceClient
    }
    
//    /// Enumeration for identifying the type of resource to request.
//    public enum Resource {
//        case individualEnrollment(programName: String, version: String)
//        case getMemberBenefits(memberId: String, version: String)
//        case getMemberProfile(programName: String, version: String)
//        case getTransactionHistory(programName: String, memberId: String, version: String)
//        case getPromotions(programName: String, version: String)
//        case enrollInPromotion(programName: String, version: String)
//        case unenrollPromotion(programName: String, version: String)
//        case getVouchers(programName: String, membershipNumber: String, version: String)
//        case getGames(participantId: String, version: String)
//        case playGame(gameParticipantRewardId: String, version: String)
//    }
//    
//    /// Get path for given API resource
//    /// - Parameter resource: A ``Resource``
//    /// - Returns: A string represents URL path of the resource
//    public func getPath(for resource: Resource) -> String {
//        
//        switch resource {
//        case .individualEnrollment(let programName, let version):
//            return ForceAPI.path(for: "loyalty-programs/\(programName)/individual-member-enrollments", version: version)
//        case .getMemberBenefits(let memberId, let version):
//            return ForceAPI.path(for: "connect/loyalty/member/\(memberId)/memberbenefits", version: version)
//        case .getMemberProfile(let programName, let version):
//            return ForceAPI.path(for: "loyalty-programs/\(programName)/members", version: version)
//        case .getTransactionHistory(let programName, let memberId, let version):
//            return ForceAPI.path(for: "loyalty/programs/\(programName)/members/\(memberId)/transaction-ledger-summary", version: version)
//        case .getPromotions(let programName, let version):
//            return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/GetMemberPromotions", version: version)
//        case .enrollInPromotion(let programName, let version):
//            return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/EnrollInPromotion", version: version)
//        case .unenrollPromotion(let programName, let version):
//			return ForceAPI.path(for: "connect/loyalty/programs/\(programName)/program-processes/OptOutOfPromotion", version: version)
//        case .getVouchers(let programName, let membershipNumber, let version):
//            return ForceAPI.path(for: "loyalty/programs/\(programName)/members/\(membershipNumber)/vouchers", version: version)
//        case .getGames(participantId: let participantId, version: let version):
//            return ForceAPI.path(for: "game/participant/\(participantId)/games", version: version)
//        case .playGame(gameParticipantRewardId: let gameParticipantRewardId, version: let version):
//            return ForceAPI.path(for: "game/gameParticipantReward/\(gameParticipantRewardId)/game-reward", version: version)
//        }
//    }

}
