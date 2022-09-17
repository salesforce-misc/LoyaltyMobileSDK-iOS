//
//  LoyaltyQueryModels.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/16/22.
//

import Foundation

public struct LoyaltyQueryModels {
    
    // SOQL Query Object
    // MARK: - Benefit
    public struct Benefit: Codable {
        let attributes: Attributes
        let benefitDescription: String?
        let id: String?

        enum CodingKeys: String, CodingKey {
            case attributes
            case benefitDescription = "Description"
            case id = "Id"
        }
    }

    // MARK: - Attributes
    public struct Attributes: Codable {
        let type, url: String
    }
}
