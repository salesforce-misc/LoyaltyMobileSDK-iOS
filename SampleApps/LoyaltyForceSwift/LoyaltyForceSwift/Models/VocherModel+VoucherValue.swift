//
//  VocherModel+VoucherValue.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 12/15/22.
//

import Foundation
import SwiftUI
import LoyaltyMobileSDK

extension VoucherModel {
    
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

