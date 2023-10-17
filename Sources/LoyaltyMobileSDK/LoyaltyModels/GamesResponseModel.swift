//
//  GamesResponseModel.swift
//
//
//  Created by Damodaram Nandi on 16/10/23.
//

import Foundation
public struct GamesResponseModel: Identifiable, Codable {
    public let id: String
    public let benefitName, benefitTypeID, benefitTypeName: String
    public let createdRecordID, createdRecordName: String?
    public let description: String?
    public let endDate: String?
    public let isActive: Bool
    public let memberBenefitStatus, startDate: String?
    
    public init(id: String,
                benefitName: String,
                benefitTypeID: String,
                benefitTypeName: String,
                createdRecordID: String?,
                createdRecordName: String?,
                description: String?,
                endDate: String?,
                isActive: Bool,
                memberBenefitStatus: String?,
                startDate: String?) {
        self.id = id
        self.benefitName = benefitName
        self.benefitTypeID = benefitTypeID
        self.benefitTypeName = benefitTypeName
        self.createdRecordID = createdRecordID
        self.createdRecordName = createdRecordName
        self.description = description
        self.endDate = endDate
        self.isActive = isActive
        self.memberBenefitStatus = memberBenefitStatus
        self.startDate = startDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.benefitName = try container.decode(String.self, forKey: .benefitName)
        self.benefitTypeID = try container.decode(String.self, forKey: .benefitTypeID)
        self.benefitTypeName = try container.decode(String.self, forKey: .benefitTypeName)
        self.createdRecordID = try container.decodeIfPresent(String.self, forKey: .createdRecordID)
        self.createdRecordName = try container.decodeIfPresent(String.self, forKey: .createdRecordName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.memberBenefitStatus = try container.decodeIfPresent(String.self, forKey: .memberBenefitStatus)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "benefitId"
        case benefitName
        case benefitTypeID = "benefitTypeId"
        case benefitTypeName
        case createdRecordID = "createdRecordId"
        case createdRecordName, description, endDate, isActive, memberBenefitStatus, startDate
    }
}
