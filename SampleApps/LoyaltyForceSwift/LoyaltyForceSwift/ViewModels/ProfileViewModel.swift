//
//  ProfileViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    
    func getProfileData(memberId: String, programName: String) async throws {
        
        do {
            let result = try await LoyaltyAPIManager.shared.getMemberProfile(for: memberId, programName: programName)
            
//            // Save to local disk
//            LocalFileManager.instance.saveData(item: result, id: memberId)
            
            await MainActor.run {
                profile = result
            }
            
        } catch {
            throw error
        }
    }
    
}
