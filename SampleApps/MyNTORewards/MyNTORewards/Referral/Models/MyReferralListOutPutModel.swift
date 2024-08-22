//
//  MyReferralListOutPutModel.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 28/03/24.
//

import Foundation
// MARK: - Referral
struct MyReferralListOutPutModel: Codable {
    let errorCode: String?
    let message: String
    let status: String
    let referralList: [Referral]?

    enum CodingKeys: String, CodingKey {
        case errorCode
        case message
        case status
        case referralList
    }
}
