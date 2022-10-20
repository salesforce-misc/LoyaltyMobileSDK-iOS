//
//  MemberModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/18/22.
//

import Foundation

struct MemberModel: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let mobileNumber: String
    let username: String
    let joinEmailList: Bool
    let dateCreated: Date
    let enrollmentDetails: EnrollmentOutputModel?
    
    init(firstName: String, lastName: String, email: String, mobileNumber: String, username: String, joinEmailList: Bool, enrollmentDetails: EnrollmentOutputModel?) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobileNumber = mobileNumber
        self.username = username
        self.joinEmailList = joinEmailList
        self.dateCreated = Date()
        self.enrollmentDetails = enrollmentDetails
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case mobileNumber
        case username
        case joinEmailList
        case dateCreated
        case enrollmentDetails
    }
}
