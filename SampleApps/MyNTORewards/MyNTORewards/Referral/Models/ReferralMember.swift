//
//  ReferralMember.swift
//  MyNTORewards
//
//  Created by Leon Qi on 1/29/24.
//

import Foundation

struct ReferralMember: Codable {
    let id: String
    let contactId: String
    let membershipNumber: String
    let programName: String
    let promotionReferralCode: String
    let enrollmentDate: Date
}
