//
//  ProfileViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    @Published var isLoading = false
    
    @MainActor
    func getProfileData(memberId: String, reload: Bool = false) async throws {
        
        isLoading = true
        
        if !reload {
            if profile == nil {
                if let cached = LocalFileManager.instance.getData(type: ProfileModel.self, id: memberId) {
                    profile = cached
                } else {
                    do {
                        try await fetchProfile(memberId: memberId)
                        isLoading = false
                    } catch {
                        throw error
                    }
                }
            }
        } else {
            do {
                try await fetchProfile(memberId: memberId)
                isLoading = false
            } catch {
                throw error
            }
            
        }
        isLoading = false
    }
    
    // Fetch profile from Salesforce
    @MainActor
    func fetchProfile(memberId: String) async throws {
        do {
            
            //let result = try await LoyaltyAPIManager.shared.getMemberProfile(for: memberId)
            let result = try await LoyaltyAPIManager.shared.getMemberProfile(for: memberId)
            
            profile = result
            // Save to local disk
            LocalFileManager.instance.saveData(item: result, id: memberId)
            
        } catch {
            throw error
        }
    }

}
