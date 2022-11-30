//
//  VoucherModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation
import SwiftUI

struct VoucherModel: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let type: String
    let faceValue: Double?
    let discountPercent: Int?
    let code: String?
    let expirationDate: String
    let image: String?
    let status: String
    
    func getVoucherValue() -> Text? {
        
        switch(type) {
        case "FixedValue":
            if let faceValue = faceValue {
                return Text("Value: **$\(String(format: "%.0f", faceValue))**")
            } else {
                return nil
            }
        case "DiscountPercentage":
            if let discountPercent = discountPercent {
                return Text("Discount: **\(discountPercent)%**")
            } else {
                return nil
            }
        case "ProductOrService": //Not sure what to do
            return nil
        default:
            return nil
        }
    }
    
}
