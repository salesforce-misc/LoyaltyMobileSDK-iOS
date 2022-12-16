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
        public let type, url: String
    }
    
    // SOQL Query Object
    // MARK: - Benefit
    public struct Benefit: Codable {
        public let attributes: Attributes
        public let benefitDescription: String?
        public let id: String?

        enum CodingKeys: String, CodingKey {
            case attributes
            case benefitDescription = "Description"
            case id = "Id"
        }
    }

    // MARK: - VoucherRecode
    public struct VoucherRecode: Codable {
        public let totalSize: Int
        public let done: Bool
        public let records: [Voucher]
    }
    
    // MARK: - Voucher
    public struct Voucher: Codable {
        public let attributes: Attributes
        public let voucherDefinition: VoucherDefinition
        public let image: String?
        public let voucherCode, expirationDate, id: String
        public let status: String

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
        public let attributes: Attributes
        public let name: String
        public let description: String?
        public let type: String
        public let faceValue: Double?
        public let discountPercent: Int?

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
