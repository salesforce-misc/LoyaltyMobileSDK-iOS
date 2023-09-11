//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
final class ProcessedReceiptViewModel: ObservableObject {

	@Published var processedAwsResponse: ProcessedAwsResponse?
    @Published var processedReceipt: ProcessedReceipt?
	@Published var isLoading: Bool = false
	@Published var isSubmittedForManualReview = false
	
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
    
    func clearProcessedReceipt() {
        processedReceipt = nil
    }
    
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
	
    func getProcessedReceiptItems(from receipt: Receipt) throws {
        let processedResponseString = receipt.processedAwsReceipt
        if let processedResponseData = processedResponseString?.data(using: .utf8) {
            processedAwsResponse = try JSONDecoder().decode(ProcessedAwsResponse.self, from: processedResponseData)
        }
    }
	
	func submitForManualReview(receiptId: String, status: String = "Manual Review", comments: String) async throws -> Bool {
		defer {
			isLoading = false
		}
		isLoading = true
		let body = [
			"receiptId": receiptId,
			"status": status,
			"comments": comments
		]
		let path = "/services/apexrest/ReceiptStatusUpdate/"
		let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
		let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path, method: "PUT", body: bodyJsonData)
		let response = try await forceClient.fetch(type: ReceiptStatusUpdateResponse.self, with: request)
		isSubmittedForManualReview = "Success" == response.status
		return isSubmittedForManualReview
	}
    
//    final func getProcessedReceiptItems() -> ProcessedAwsResponse {
//        return ProcessedAwsResponse(totalAmount: "$1568",
//                                    storeName: "East Repair Inc",
//                                    storeAddress: "",
//                                    receiptNumber: "US-001",
//                                    receiptDate: "11/02/2019",
//                                    memberShipNumber: "435234534",
//                                    lineItem: [ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
//                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
//                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
//                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
//                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599"),
//                                               ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599")
//                                               ])
//    }
}

struct ReceiptStatusUpdateResponse: Decodable {
	let status: String
	let message: String
	let errorCode: String
}
