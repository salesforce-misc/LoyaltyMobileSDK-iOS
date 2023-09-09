//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation
import LoyaltyMobileSDK

class ProcessedReceiptViewModel: ObservableObject {

	@Published var processedAwsResponse: ProcessedAwsResponse?
    @Published var processedReceipt: ProcessedReceipt?
	
    private let authManager: ForceAuthenticator
    private var forceClient: ForceClient
    private let localFileManager: FileManagerProtocol
    
    init(
        localFileManager: FileManagerProtocol = LocalFileManager.instance,
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil
    ) {
        self.localFileManager = localFileManager
        self.authManager = authManager
        self.forceClient = forceClient ?? ForceClient(auth: authManager)
    }
    
    @MainActor
    func processImage(membershipNumber: String, base64Image: String) async throws {
        
        let body = [
            "memberShipNumber": membershipNumber,
            "base64image": base64Image
        ]
        
        do {
            let path = "/services/apexrest/AnalizeExpence/"
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path, method: "POST", body: bodyJsonData)
            processedReceipt = try await forceClient.fetch(type: ProcessedReceipt.self, with: request)
            if let processedReceipt = processedReceipt {
                Logger.debug("\(processedReceipt)")
            }
        } catch {
            throw error
        }
    }
    
    final func getProcessedReceiptItems(from receipt: Receipt) throws {
        let processedResponseString = receipt.processedAwsReceipt
        if let processedResponseData = processedResponseString?.data(using: .utf8) {
            processedAwsResponse = try JSONDecoder().decode(ProcessedAwsResponse.self, from: processedResponseData)
        }
    }
    
    final func getProcessedReceiptItems() -> ProcessedAwsResponse {
        return ProcessedAwsResponse(totalAmount: "$1568",
                                    storeName: "East Repair Inc",
                                    storeAddress: "",
                                    receiptNumber: "US-001",
                                    receiptDate: "11/02/2019",
                                    memberShipNumber: "435234534",
                                    lineItem: [ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599")
                                               ])
    }
}
