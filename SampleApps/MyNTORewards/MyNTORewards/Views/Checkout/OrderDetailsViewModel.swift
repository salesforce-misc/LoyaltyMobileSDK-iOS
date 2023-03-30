//
//  OrderDetailsViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
final class OrderDetailsViewModel: ObservableObject {
	@Published var selectedIndex = 0
	@Published var isOrderPlacedNavigationActive = false
	var orderId = ""
	
	func createOrder() async {
		do {
			orderId = try await placeOrder()
			isOrderPlacedNavigationActive = true
		} catch {
			print("Unable to place order")
		}
		
	}
	
	func selectTabIndex(_ index: Int) {
		selectedIndex = index
	}
	
	private var authManager: ForceAuthManager
	private var forceClient: ForceClient
	
	init(authManager: ForceAuthManager = .shared, forceClient: ForceClient? = nil) {
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
	}
	
	private func placeOrder(productName: String = "Men's Rainier L4 Windproof Soft Shell Hoodie",
							 redeemPoints: Double = 0,
							 productPrice: Double = 0,
							 orderTotal: Double = 0,
							 useNTOPoints: Bool = false,
							 pointsBalance: Double = 0,
							 shippingStreet: String = "",
							 billingStreet: String = "",
							 voucherCode: String = "",
							 membershipNumber: String = ""
	) async throws -> String {
		let order = Order(productName: productName,
						  redeemPoints: redeemPoints,
						  productPrice: productPrice,
						  orderTotal: orderTotal,
						  useNTOPoints: useNTOPoints,
						  pointsBalance: pointsBalance,
						  shippingStreet: shippingStreet,
						  billingStreet: billingStreet,
						  voucherCode: voucherCode,
						  membershipNumber: membershipNumber)
		do {
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .formatted(.forceFormatter())
			let requestBody = try encoder.encode(order)
			let path = "services/apexrest/NTOOrderCheckOut/"
			let request = try ForceRequest.create(path: path, method: "POST", body: requestBody)
			return try await forceClient.fetch(type: String.self, with: request)
		} catch {
			throw error
		}
	}
}

struct Order: Codable {
	let productName: String?
	let redeemPoints: Double?
	let productPrice: Double?
	let orderTotal: Double?
	let useNTOPoints: Bool?
	let pointsBalance: Double?
	let shippingStreet: String?
	let billingStreet: String?
	let voucherCode: String?
	let membershipNumber: String?
}
