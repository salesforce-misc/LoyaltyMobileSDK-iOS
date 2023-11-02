//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation
import LoyaltyMobileSDK
import SwiftUI
import Photos

enum ReceiptStatus: String {
	case manualReview = "Manual Review"
	case draft = "Draft"
	case inProgress = "In Progress"
	case processed = "Processed"
	case cancelled = "Cancelled"
}

enum ReceiptScanStatus {
    case allEligibleItems
    case bothEligibleAndInEligibleItems
    case noEligibleItems
    case receiptNotReadable
    case receiptPartiallyReadable
}

@MainActor
final class ProcessedReceiptViewModel: ObservableObject {
	@Published var processedAwsResponse: ProcessedAwsResponse?
    @Published var processedReceipt: ProcessedReceipt?
    @Published var processedError: String?
	@Published var isSubmittedForManualReview = false
	@Published var receiptState: ReceiptState = .processing
	@Published var eligibleItems = [ProcessedReceiptItem]()
	@Published var inEligibleItems = [ProcessedReceiptItem]()
    @Published var processedStepTitle: String = "Uploading receipt image…"
    @Published var currentStep: Int = 1
    @Published var receiptScanSatus: ReceiptScanStatus = .bothEligibleAndInEligibleItems
	
    private let authManager: ForceAuthenticator
    private var forceClient: ForceClient
    private let localFileManager: FileManagerProtocol
	private let soqlManager: SOQLManager
    
    init(
        localFileManager: FileManagerProtocol = LocalFileManager.instance,
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil, soqlManager: SOQLManager? = nil
    ) {
        self.localFileManager = localFileManager
        self.authManager = authManager
        self.forceClient = forceClient ?? ForceClient(auth: authManager)
		self.soqlManager = soqlManager ?? SOQLManager(forceClient: self.forceClient)
    }
    
    func clearProcessedReceipt() {
        processedReceipt = nil
        processedError = nil
    }
    
    func uploadImage(membershipNumber: String, imageData: Data) async throws {
        let queryItems = [
            "membershipnumber": membershipNumber
        ]

        let headers = ["Content-Type": "image/jpeg"]

        do {
            let path = "/services/apexrest/upload-receipt/"
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(),
                                                  path: path,
                                                  method: "PUT",
                                                  queryItems: queryItems,
                                                  headers: headers,
                                                  body: imageData)
           let  processedReceipt = try await forceClient.fetch(type: ReceiptStatusUpdateResponse.self, with: request)
            if processedReceipt.status == "Success", !processedReceipt.message.isEmpty {
                // call Api
                processedStepTitle = "Processing receipt information..."
                currentStep = 2
                try await processImage(membershipNumber: membershipNumber, imageInfo: processedReceipt.message)
            }
           
        } catch CommonError.responseUnsuccessful(_, let displayMessage), CommonError.unknownException(let displayMessage) {
            receiptState = .processed
            processedError = displayMessage
        } catch {
            receiptState = .processed
            processedError = error.localizedDescription
        }
    }
	
    func processImage(membershipNumber: String, imageInfo: String) async throws {
        let queryItems = [
            "membershipnumber": membershipNumber,
            "filename": imageInfo
        ]

        do {
            let path = "/services/apexrest/expense-analysis/"
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(),
                                                  path: path,
                                                  method: "POST",
                                                  queryItems: queryItems
                                                  )
            processedReceipt = try await forceClient.fetch(type: ProcessedReceipt.self, with: request)
            (eligibleItems, inEligibleItems) = split(lineItems: processedReceipt?.lineItem)
            receiptState = .processed
            switch processedReceipt?.confidenceStatus {
            case .failure:
                print("not Readble")
            case .partial:
                print("partial Readble")
            case .success:
                print(" Readble")
            case .none:
                print("none")
            }
            if let processedReceipt = processedReceipt {
                Logger.debug("\(processedReceipt)")
            }
		} catch CommonError.responseUnsuccessful(_, let displayMessage), CommonError.unknownException(let displayMessage) {
            receiptState = .processed
			processedError = displayMessage
		} catch {
			receiptState = .processed
			processedError = error.localizedDescription
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
		lineItems?.forEach { $0.isEligible ?? false ? eligibleItems.append($0) : inEligibleItems.append($0)}
		return (eligibleItems, inEligibleItems)
	}
	
    func updateStatus(receiptId: String?, status: ReceiptStatus, comments: String = "") async throws -> Bool {
		guard let receiptId = receiptId else { throw CommonError.requestFailed(message: "Receipt Id not found") }
		
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
	
	func wait(
		until status: ReceiptStatus,
		forReceiptId receiptId: String,
		membershipNumber: String,
		delay seconds: Double,
		retryCount: Int) async -> Receipt? {
			var retryCount = retryCount
			repeat {
				retryCount -= 1
				do {
					try await Task.sleep(nanoseconds: UInt64(seconds * Double(NSEC_PER_SEC)))
					let receipt = try await soqlManager.getReceipt(membershipNumber: membershipNumber, id: receiptId)
					if receipt?.status == status.rawValue { return receipt }
				} catch {
					Logger.debug("Error: Unable to verify status, \(error)")
				}
			} while retryCount > 0
			return nil
		}
}
