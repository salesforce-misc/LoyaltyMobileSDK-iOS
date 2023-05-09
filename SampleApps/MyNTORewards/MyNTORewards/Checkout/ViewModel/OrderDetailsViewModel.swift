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
    @Published var shippingAddress: ShippingAddress?
	
	private var orderId = ""
    private let checkout_shipping_method = "/services/apexrest/ShippingMethods/"
    private let checkout_shipping_address_query = "SELECT shippingAddress,billingAddress from Account"
    private let authManager: CheckoutAuthManager
    private var checkoutNetworkClient: CheckoutNetworkClient
	
	init(
		authManager: CheckoutAuthManager = .shared,
		checkoutNetworkClient: CheckoutNetworkClient? = nil,
		index: Int = 0
	) {
		self.authManager = authManager
		self.checkoutNetworkClient = checkoutNetworkClient ?? CheckoutNetworkClient(auth: authManager)
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
			let request = try ForceRequest.create(instanceURL: CheckoutConfig.Defaults.baseURL,
												  path: CheckoutConfig.Defaults.orderCheckout,
												  method: "POST",
												  body: requestBody)
			return try await checkoutNetworkClient.fetch(type: String.self, with: request)
		} catch {
			throw error
		}
	}
	
	func getOrderDetails() async throws -> OrderDetails {
		do {
			let queryItems = ["orderId": "\(orderId)"]
			let request = try ForceRequest.create(instanceURL: CheckoutConfig.Defaults.baseURL,
												  path: CheckoutConfig.Defaults.orderCheckout,
												  method: "GET",
												  queryItems: queryItems)
			return try await checkoutNetworkClient.fetch(type: OrderDetails.self, with: request)
		} catch {
			throw error
		}
	}
    
    func getShippingType(devMode: Bool = false) async throws -> [ShippingMethod] {
        do {
            if devMode {
                let result = try checkoutNetworkClient.fetchLocalJson(type: [ShippingMethod].self,
																	  file: "ShippingMethod")
                return result
            }
            
            let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(),
												  path: checkout_shipping_method,
												  method: "GET")
            let result = try await checkoutNetworkClient.fetch(type: [ShippingMethod].self,
															   with: request)
            return result
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getShippingAddress(membershipNumber: String) async throws {
        do {
            let queryResult = try await checkoutNetworkClient.SOQL(type: ShippingAddressRecord.self,
																   for: checkout_shipping_address_query)
            shippingAddress = queryResult.records.compactMap { $0.shippingAddress }.first
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
