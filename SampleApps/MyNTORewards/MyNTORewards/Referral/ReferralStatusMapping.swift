//
//  ReferralStatusMapping.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/16/24.
//

import Foundation

enum PromotionStageType: String {
    case sent = "Advocate Refers Friend"
    case accepted = "Friend Signs Up"
    case voucherEarned = "Friend Completes First Purchase"
}

enum ReferralStatus: String {
    case invitationSent = "Invitation Sent"
    case signedUp = "Signed Up"
    case purchaseCompleted = "Purchase Completed"
    case unknown = "Unknown" // Default case
}

let mapping: [String: ReferralStatus] = [
    "Advocate Refers Friend": .invitationSent,
    "Friend Signs Up": .signedUp,
    "Friend Completes First Purchase": .purchaseCompleted
]

extension PromotionStageType {
    var correspondingReferralStatus: ReferralStatus {
        return mapping[self.rawValue] ?? .unknown
    }
}
