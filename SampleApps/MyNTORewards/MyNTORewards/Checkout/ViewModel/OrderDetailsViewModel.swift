//
//  OrderDetailsViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 28/03/23.
//

import Foundation
import LoyaltyMobileSDK
import GamificationMobileSDK_iOS

@MainActor
class OrderDetailsViewModel: ObservableObject {
	@Published var isOrderPlacedNavigationActive = false
	@Published var isOrderPlacedWithGameNavigationActive = false
    @Published var shippingAddress: ShippingAddress?
	
	var orderId = ""
	var gameParticipantRewardId = ""
	var gameDefinition: GameDefinition?
	var gameType: GameType?
    private let checkout_shipping_method = "/services/apexrest/ShippingMethods/"
    private let checkout_shipping_address_query = "SELECT shippingAddress,billingAddress from Account"
	private let orderApiEndpoint = "services/apexrest/NTOOrderCheckOutAndGameParticipantReward/"
    private let authManager: ForceAuthManager
    private var forceClient: ForceClient
	
	init(
		authManager: ForceAuthManager = .shared,
		forceClient: ForceClient? = nil
	) {
		self.authManager = authManager
		self.forceClient = forceClient ?? ForceClient(auth: authManager)
	}
	
	func createOrder(
		reloadables: [Reloadable],
		productVM: ProductViewModel,
		profileVM: ProfileViewModel,
		membershipNumber: String?) async throws {
		do {
			let productPrice = Double(productVM.basePrice)
			let orderTotal = Double(productVM.getTotalAmount())
			let pointsBalance = profileVM.profile?.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName) ?? 0
			
			let placedOrderResponse = try await placeOrder(productPrice: productPrice,
										   orderTotal: orderTotal,
										   pointsBalance: pointsBalance,
										   membershipNumber: membershipNumber ?? "")
			orderId = placedOrderResponse.orderId
			gameParticipantRewardId = placedOrderResponse.gameParticipantRewardId
		} catch {
            Logger.error("Unable to place order: \(error.localizedDescription)")
            throw error
		}
	}
    
    func reloadAfterOrderPlaced(reloadables: [Reloadable], memberId: String?, membershipNumber: String?) async throws {
        do {
            for reloadable in reloadables {
                try await reloadable.reload(id: memberId ?? "", number: membershipNumber ?? "")
            }
        } catch {
            Logger.error("Unable to reload: \(error.localizedDescription)")
            throw error
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
	) async throws -> PlacedOrderResponse {
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
            // TODO : Need to update 
//			encoder.dateEncodingStrategy = .formatted(.forceFormatter())
			let requestBody = try encoder.encode(order)
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(),
												  path: self.orderApiEndpoint,
												  method: "POST",
												  body: requestBody)
			return try await forceClient.fetch(type: PlacedOrderResponse.self, with: request)
		} catch {
			throw error
		}
	}
	
	func getOrderDetails() async throws -> OrderDetails {
		do {
			let queryItems = ["orderId": "\(orderId)"]
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(),
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
            
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(),
												  path: checkout_shipping_method,
												  method: "GET")
            let result = try await forceClient.fetch(type: [ShippingMethod].self,
															   with: request)
            return result
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
    
    func getShippingAddress(membershipNumber: String) async throws {
        do {
            let queryResult = try await forceClient.SOQL(type: ShippingAddressRecord.self,
                                                         for: checkout_shipping_address_query)
            shippingAddress = queryResult.records.compactMap { $0.shippingAddress }.first
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
}
