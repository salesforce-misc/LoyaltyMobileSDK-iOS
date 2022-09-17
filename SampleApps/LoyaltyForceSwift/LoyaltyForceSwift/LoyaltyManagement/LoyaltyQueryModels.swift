//
//  LoyaltyQueryModels.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/16/22.
//

import Foundation

/// Each model is created for JSONDecoder to decode to QueryResult<T>
/// Alternative is to use generic Record model, which will be decoded to QueryResult<Record>
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
