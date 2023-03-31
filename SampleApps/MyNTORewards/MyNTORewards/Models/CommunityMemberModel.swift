//
//  CommunityMemberModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/30/23.
//

import Foundation

struct CommunityMemberModel: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let loyaltyProgramMemberId: String
    let loyaltyProgramName: String
    let membershipNumber: String
}
