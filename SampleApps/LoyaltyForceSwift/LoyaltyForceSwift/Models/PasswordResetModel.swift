//
//  PasswordResetModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/4/22.
//

import Foundation

struct PasswordResetModel: Codable {
    let email: String
    let requestType: String
}
