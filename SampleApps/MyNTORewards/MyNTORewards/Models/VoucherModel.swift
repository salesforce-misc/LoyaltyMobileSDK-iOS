//
//  VoucherModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation

public struct VoucherModel: Codable, Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let type: String
    public let faceValue: Double?
    public let discountPercent: Int?
    public let code: String?
    public let expirationDate: String
    public let image: String?
    public let status: String
    
}
