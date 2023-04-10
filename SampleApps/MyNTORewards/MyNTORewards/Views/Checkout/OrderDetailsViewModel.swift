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
    @Published var shippingAddress: ShippingAddress?
    
    private let authManager = ForceAuthManager.shared
    private var loyaltyAPIManager: LoyaltyAPIManager
    private var forceClient: ForceClient
    
    init() {
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager, loyaltyProgramName: AppConstants.Config.loyaltyProgramName)
        forceClient = ForceClient(auth: authManager)
    }
	
	func createOrder() {
		isOrderPlacedNavigationActive = true
	}
	
	func selectTabIndex(_ index: Int) {
		selectedIndex = index
	}
    
    func getShippingType(devMode: Bool = false) async throws -> [ShippingMethod] {
        do {
            if devMode {
                let result = try forceClient.fetchLocalJson(type: [ShippingMethod].self, file: "ShippingMethod")
                return result
            }
            
            let request = try ForceRequest.create(path: "/services/apexrest/ShippingMethods/", method: "GET")
            let result = try await forceClient.fetch(type: [ShippingMethod].self, with: request)
            return result
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getShippingAddress(membershipNumber: String) async throws {
        do {
            let query = "SELECT shippingAddress,billingAddress from Account"
            let queryResult = try await forceClient.SOQL(type: ShippingAddressRecord.self, for: query)
            shippingAddress = queryResult.records.compactMap { $0.shippingAddress }.first
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
}
