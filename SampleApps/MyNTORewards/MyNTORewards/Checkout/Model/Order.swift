//
//  Order.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/05/23.
//

import Foundation

struct Order: Codable {
	let productName: String
	let redeemPoints: Double
	let productPrice: Double
	let orderTotal: Double
	let useNTOPoints: Bool
	let pointsBalance: Double
	let shippingStreet: String
	let billingStreet: String
	let voucherCode: String
	let membershipNumber: String
}

struct OrderAttributes: Codable {
	let type: String
	let url: String
}

struct OrderDetails: Codable {
	let attributes: OrderAttributes
	let id: String
	let orderNumber: String
	let activatedDate: String
	
	enum CodingKeys: String, CodingKey {
		case attributes
		case id = "Id"
		case orderNumber = "OrderNumber"
		case activatedDate = "ActivatedDate"
	}
}

struct PlacedOrderResponse: Decodable {
	let orderId: String
	let gameParticipantRewardId: String
}
