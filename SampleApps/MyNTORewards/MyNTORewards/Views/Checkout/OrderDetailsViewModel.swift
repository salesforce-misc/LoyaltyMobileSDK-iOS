//
//  OrderDetailsViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor

class OrderDetailsViewModel: ObservableObject {
	@Published var selectedIndex: Int
	@Published var isOrderPlacedNavigationActive = false
	var orderId = ""
    @Published var shippingAddress: ShippingAddress?
    
    private let checkout_shipping_method = "/services/apexrest/ShippingMethods/"
    private let checkout_shipping_address_query = "SELECT shippingAddress,billingAddress from Account"
    private let authManager: ForceAuthManager
    private var forceClient: ForceClient
	
	init(authManager: ForceAuthManager = .shared, forceClient: ForceClient? = nil, index: Int = 0) {
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
		self.selectedIndex = index
	}
	
	func createOrder() async {
		do {
			orderId = try await placeOrder()
			isOrderPlacedNavigationActive = true
		} catch {
			print("Unable to place order")
		}
	}
	
	private func placeOrder(
		productName: String = "Men's Rainier L4 Windproof Soft Shell Hoodie",
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
			let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(), path: path, method: "POST", body: requestBody)
			return try await forceClient.fetch(type: String.self, with: request)
		} catch {
			throw error
		}
	}
	
	func getOrderDetails() async throws -> OrderDetails {
		do {
			let path = "services/apexrest/NTOOrderCheckOut/"
			let queryItems = ["orderId": "\(orderId)"]
			let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(), path: path, method: "GET", queryItems: queryItems)
			return try await forceClient.fetch(type: OrderDetails.self, with: request)
		} catch {
			throw error
		}
	}
    
    func getShippingType(devMode: Bool = false) async throws -> [ShippingMethod] {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: [ShippingMethod].self, file: "ShippingMethod")
                return result
            }
            
            let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(), path: checkout_shipping_method, method: "GET")
            let result = try await forceClient.fetch(type: [ShippingMethod].self, with: request)
            return result
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getShippingAddress(membershipNumber: String) async throws {
        do {
            let queryResult = try await forceClient.SOQL(type: ShippingAddressRecord.self, for: checkout_shipping_address_query)
            shippingAddress = queryResult.records.compactMap { $0.shippingAddress }.first
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

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
