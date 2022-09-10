//
//  ProfileViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    @Published var isLoaded = false
    
    func getProfileData(memberId: String) async throws {
        
        do {
            isLoaded = false
            
            let auth = try await ForceAuthManager.shared.grantAuth(username: ForceConfig.username, password: ForceConfig.password)
            
            let request = try ForceRequest.create(
                auth: auth,
                method: "GET",
                path: ForceConfig.path(for: "loyalty-programs/NTO Insider/members"),
                queryItems: ["memberId": "\(memberId)"])
            
            let result = try await ForceClient.shared.fetch(type: ProfileModel.self, with: request)
            
            await MainActor.run {
                isLoaded = true
                profile = result
            }
            
        } catch {
            throw error
        }
    }
    
}
