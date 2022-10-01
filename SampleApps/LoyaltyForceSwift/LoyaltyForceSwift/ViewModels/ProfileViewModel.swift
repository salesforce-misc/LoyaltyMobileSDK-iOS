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
    
    func getProfileData(memberId: String, programName: String) async throws {
        
        do {
            await MainActor.run {
                isLoaded = false
                profile = nil
            }
            
            let result = try await LoyaltyAPIManager.shared.getMemberProfile(for: memberId, programName: programName)
            
            await MainActor.run {
                isLoaded = true
                profile = result
            }
            
        } catch {
            throw error
        }
    }
    
}
