//
//  ProcessedReceiptViewModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import Foundation
import LoyaltyMobileSDK

class ProcessedReceiptViewModel: ObservableObject {
    private let authManager: ForceAuthenticator
    private var forceClient: ForceClient
    private let localFileManager: FileManagerProtocol
    
    @Published var processedReceipt: ProcessedReceipt?
    
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
        
        //print(base64Image)
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
}
