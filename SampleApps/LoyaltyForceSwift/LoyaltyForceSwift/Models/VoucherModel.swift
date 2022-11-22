//
//  VoucherModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation

struct VoucherModel: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let code: String
    let expirationDate: String
    let image: String?
    let status: String
}
