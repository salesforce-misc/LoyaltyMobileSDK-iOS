//
//  ShippingMethodModel.swift
//  
//
//  Created by Anandhakrishnan Kanagaraj on 29/03/23.
//

import Foundation

// MARK: - ShippingMethod
public struct ShippingMethod: Codable {
    let attributes: Attributes
    let shippingCodeC, shippingTypeC, id: String

    enum CodingKeys: String, CodingKey {
        case attributes
        case shippingCodeC = "Shipping_Code__c"
        case shippingTypeC = "Shipping_Type__c"
        case id = "Id"
    }
}

// MARK: - Attributes
public struct Attributes: Codable {
    let type, url: String
}
