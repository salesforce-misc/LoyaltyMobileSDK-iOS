//
//  ShippingAddressRecord.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 04/04/23.
//

// MARK: - Welcome
struct ShippingAddressRecord: Codable {
    let attributes: ShippingAddressAttribute
    let shippingAddress: ShippingAddress?
    let billingAddress: ShippingAddress?

    enum CodingKeys: String, CodingKey {
        case attributes
        case shippingAddress = "ShippingAddress"
        case billingAddress = "BillingAddress"
    }
}

// MARK: - Attributes
struct ShippingAddressAttribute: Codable {
    let type, url: String
}

// MARK: - ShippingAddress
struct ShippingAddress: Codable {
    let city, country: String?
    let geocodeAccuracy, latitude, longitude: String?
    let postalCode, state: String?
    let street: String
}
