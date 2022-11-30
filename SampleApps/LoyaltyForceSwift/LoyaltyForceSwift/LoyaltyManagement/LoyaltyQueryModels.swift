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
    
    // MARK: - Attributes
    // Shared with other QueryRecord
    public struct Attributes: Codable {
        let type, url: String
    }
    
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

    // MARK: - VoucherRecode
    public struct VoucherRecode: Codable {
        let totalSize: Int
        let done: Bool
        let records: [Voucher]
    }
    
    // MARK: - Voucher
    public struct Voucher: Codable {
        let attributes: Attributes
        let voucherDefinition: VoucherDefinition
        let image: String?
        let voucherCode, expirationDate, id: String
        let status: String

        enum CodingKeys: String, CodingKey {
            case attributes
            case voucherDefinition = "VoucherDefinition"
            case image = "Image__c"
            case voucherCode = "VoucherCode"
            case expirationDate = "ExpirationDate"
            case id = "Id"
            case status = "Status"
        }
    }
    
    // MARK: - VoucherDefinition
    public struct VoucherDefinition: Codable {
        let attributes: Attributes
        let name: String
        let description: String?
        let type: String
        let faceValue: Double?
        let discountPercent: Int?

        enum CodingKeys: String, CodingKey {
            case attributes
            case name = "Name"
            case description = "Description"
            case type = "Type"
            case faceValue = "FaceValue"
            case discountPercent = "DiscountPercent"
        }
        
    }
}
