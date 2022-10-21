//
//  MemberModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/18/22.
//

import Foundation

struct MemberModel: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let mobileNumber: String
    let username: String
    let joinEmailList: Bool
    let dateCreated: Date
    let enrollmentDetails: EnrollmentDetails
}

struct EnrollmentDetails: Codable {
    let loyaltyProgramMemberId: String
    let loyaltyProgramName: String
    let membershipNumber: String
}
