//
//  CapturedImageViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/22/23.
//

import Foundation
import LoyaltyMobileSDK

class CapturedImageViewModel: ObservableObject {
    
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
    
    func uploadImage(base64Image: String) async throws -> Receipt {
        
        let body = [
            "base64image": base64Image
        ]
        
        do {
            let path = "/services/apexrest/AnalizeExpence/"
            let bodyJsonData = try JSONSerialization.data(withJSONObject: body)
            let request = try ForceRequest.create(instanceURL: AppSettings.shared.getInstanceURL(), path: path, method: "POST", body: bodyJsonData)
            return try await forceClient.fetch(type: Receipt.self, with: request) // To be verified with real API response
        } catch {
            throw error
        }
    }
}
