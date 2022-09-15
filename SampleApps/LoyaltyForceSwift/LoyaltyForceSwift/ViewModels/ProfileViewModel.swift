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
            profile = nil
                        
            // TODO: get program name after login
            let programName = "NTO Insider"
            let path = ForceConfig.path(for: LoyaltyAPIManager.getPath(for: .getMemberProfile(programName: programName)))
            let queryItems = ["memberId": "\(memberId)"]
            let request = try ForceRequest.create(method: "GET", path: path, queryItems: queryItems)
            
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
