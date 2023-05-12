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
	private let orderApiEndpoint = "services/apexrest/NTOOrderCheckOut/"
    private let authManager: ForceAuthManager
    private var forceClient: ForceClient
	private var localFileManager: LocalFileManager
	
	init(
		authManager: ForceAuthManager = .shared,
		localFileManager: LocalFileManager = .instance,
		forceClient: ForceClient? = nil,
		index: Int = 0
	) {
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
		self.selectedIndex = index
		self.localFileManager = localFileManager
	}
	
	func createOrder(clearable: Clearable, memberId: String?, membershipNumber: String?) async {
		do {
			orderId = try await placeOrder(membershipNumber: membershipNumber ?? "")
			// invalidating the cache after order is created successfully in order to make the profile page reload when it is visited.
			await clearable.clear()
			localFileManager.removeData(type: ProfileModel.self, id: memberId ?? "")
			isOrderPlacedNavigationActive = true
		} catch {
			Logger.error("Unable to place order")
		}
	}
	
	private func placeOrder(
		productName: String = "Men's Rainier L4 Windproof Soft Shell Hoodie",
		redeemPoints: Double = 0,
		productPrice: Double = 200,
		orderTotal: Double = 207,
		useNTOPoints: Bool = false,
		pointsBalance: Double = 0,
		shippingStreet: String = "1520 W 62nd St Cook IL 60636",
		billingStreet: String = "1520 W 62nd St Cook IL 60636",
		voucherCode: String = "",
		membershipNumber: String
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
			let request = try ForceRequest.create(instanceURL: AppSettings.connectedApp.instanceURL,
												  path: self.orderApiEndpoint,
												  method: "POST",
												  body: requestBody)
			return try await forceClient.fetch(type: String.self, with: request)
		} catch {
			throw error
		}
	}
	
	func getOrderDetails() async throws -> OrderDetails {
		do {
			let queryItems = ["orderId": "\(orderId)"]
			let request = try ForceRequest.create(instanceURL: AppSettings.connectedApp.instanceURL,
												  path: self.orderApiEndpoint,
												  method: "GET",
												  queryItems: queryItems)
			return try await forceClient.fetch(type: OrderDetails.self, with: request)
		} catch {
			throw error
		}
	}
    
    func getShippingType(devMode: Bool = false) async throws -> [ShippingMethod] {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: [ShippingMethod].self,
																	  file: "ShippingMethod")
                return result
            }
            
            let request = try ForceRequest.create(instanceURL: AppSettings.getInstanceURL(),
												  path: checkout_shipping_method,
												  method: "GET")
            let result = try await forceClient.fetch(type: [ShippingMethod].self,
															   with: request)
            return result
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getShippingAddress(membershipNumber: String) async throws {
        do {
            let queryResult = try await forceClient.SOQL(type: ShippingAddressRecord.self,
																   for: checkout_shipping_address_query)
            shippingAddress = queryResult.records.compactMap { $0.shippingAddress }.first
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
