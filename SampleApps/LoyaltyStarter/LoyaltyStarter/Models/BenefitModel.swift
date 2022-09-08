//
//  MemberBenefitModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation

// MARK: - MemberBenefits
struct Benefits: Codable {
    let memberBenefits: [BenefitModel]
}

// MARK: - MemberBenefit
struct BenefitModel: Identifiable, Codable {
    let id, benefitName, benefitTypeID, benefitTypeName: String
    let createdRecordID, createdRecordName: String?
    let endDate: String?
    let isActive: Bool
    let memberBenefitStatus, startDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "benefitId"
        case benefitName
        case benefitTypeID = "benefitTypeId"
        case benefitTypeName
        case createdRecordID = "createdRecordId"
        case createdRecordName, endDate, isActive, memberBenefitStatus, startDate
    }
}
