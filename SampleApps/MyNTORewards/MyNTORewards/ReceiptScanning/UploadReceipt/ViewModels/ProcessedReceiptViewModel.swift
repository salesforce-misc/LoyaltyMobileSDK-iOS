//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation
import LoyaltyMobileSDK

enum ReceiptStatus: String {
	case manualReview = "Manual Review"
	case draft = "Draft"
	case inProgress = "In Progress"
	case processed = "Processed"
	case cancelled = "Cancelled"
}

@MainActor
final class ProcessedReceiptViewModel: ObservableObject {
	@Published var processedAwsResponse: ProcessedAwsResponse?
    @Published var processedReceipt: ProcessedReceipt?
    @Published var processedError: Error?
	@Published var isSubmittedForManualReview = false
	@Published var receiptState: ReceiptState = .processing
	@Published var eligibleItems = [ProcessedReceiptItem]()
	@Published var inEligibleItems = [ProcessedReceiptItem]()
	
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
        processedError = nil
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
			(eligibleItems, inEligibleItems) = split(lineItems: processedReceipt?.lineItem)
			receiptState = .processed
            if let processedReceipt = processedReceipt {
                Logger.debug("\(processedReceipt)")
            }
        } catch {
			receiptState = .processed
            processedError = error
            throw error
        }
    }
	
    func getProcessedReceiptItems(from receipt: Receipt) async throws {
        let processedResponseString = receipt.processedAwsReceipt
        if let processedResponseData = processedResponseString?.data(using: .utf8) {
            processedAwsResponse = try JSONDecoder().decode(ProcessedAwsResponse.self, from: processedResponseData)
			(eligibleItems, inEligibleItems) = split(lineItems: processedAwsResponse?.lineItem)
        }
    }
	
	private func split(lineItems: [ProcessedReceiptItem]?) -> (eligible: [ProcessedReceiptItem], inEligible: [ProcessedReceiptItem]) {
		var eligibleItems = [ProcessedReceiptItem]()
		var inEligibleItems = [ProcessedReceiptItem]()
		lineItems?.forEach { $0.isEligible ? eligibleItems.append($0) : inEligibleItems.append($0)}
		return (eligibleItems, inEligibleItems)
	}
	
    func updateStatus(receiptId: String, status: ReceiptStatus, comments: String = "") async throws -> Bool {
		let body = [
			"receiptId": receiptId,
			"status": status.rawValue,
			"comments": comments
		]
		let path = "/services/apexrest/ReceiptStatusUpdate/"
		let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
		let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path, method: "PUT", body: bodyJsonData)
		let response = try await forceClient.fetch(type: ReceiptStatusUpdateResponse.self, with: request)
		isSubmittedForManualReview = "Success" == response.status
		return isSubmittedForManualReview
	}
}
