//
//  ProfileViewModel.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 9/8/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    @Published var isLoaded = false
    
    func getProfileData(memberId: String) async throws {
        
        do {
            isLoaded = false
            let result = try await NetworkManager.connection.rest(
                type: ProfileModel.self,
                method: "GET",
                version: AppConstants.Config.apiVersion,
                path: "/loyalty-programs/NTO Insider/members",
                queryItems: ["memberId": "\(memberId)"])
            
            await MainActor.run {
                isLoaded = true
                profile = result
            }
            
        } catch {
            throw error
        }
    }
    
}
