//
//  MemberBenefitModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/26/22.
//

import Foundation

// MARK: - MemberBenefits
public struct Benefits: Codable {
    let memberBenefits: [BenefitModel]
}

// MARK: - MemberBenefit
public struct BenefitModel: Identifiable, Codable {
    public let id: String
    let benefitName, benefitTypeID, benefitTypeName: String
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
    
    func getBenefitDescription(benefitId: String) async -> String {
        do {
//            let result = try await LoyaltyAPIManager.shared.getBenefit(by: benefitId)
//            guard let description = result.first?.benefitDescription else {
//                return ""
//            }
            
            let result = try await LoyaltyAPIManager.shared.getBenefitRecord(by: benefitId)
            guard let description = result.first?.string(forField: "Description") else {
                return ""
            }
            return description
        } catch {
            print("Error getting benefit description: \(error)")
            return ""
        }
    }
    
}
