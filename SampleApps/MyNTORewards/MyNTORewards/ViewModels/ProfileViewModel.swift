//
//  ProfileViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/9/22.
//

import Foundation
import LoyaltyMobileSDK

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    @Published var isLoading = false
    
    private let authManager: ForceAuthenticator
    private let localFileManager: FileManagerProtocol
    private var loyaltyAPIManager: LoyaltyAPIManager
    
    init(authManager: ForceAuthenticator = ForceAuthManager.shared, localFileManager: FileManagerProtocol = LocalFileManager.instance) {
        self.authManager = authManager
        self.localFileManager = localFileManager
        loyaltyAPIManager = LoyaltyAPIManager(auth: authManager,
                                              loyaltyProgramName: AppSettings.Defaults.loyaltyProgramName,
                                              instanceURL: AppSettings.getInstanceURL())
    }
    
    func getProfileData(memberId: String, reload: Bool = false, devMode: Bool = false) async throws {
        
        isLoading = true
        
        if !reload {
            if profile == nil {
                if let cached = localFileManager.getData(type: ProfileModel.self, id: memberId, folderName: nil) {
                    profile = cached
                } else {
                    do {
                        try await fetchProfile(memberId: memberId, devMode: devMode)
                        isLoading = false
                    } catch {
                        throw error
                    }
                }
            }
        } else {
            do {
                try await fetchProfile(memberId: memberId, devMode: devMode)
                isLoading = false
            } catch {
                throw error
            }
            
        }
        isLoading = false
    }
    
    // Fetch profile from Salesforce
    func fetchProfile(memberId: String, devMode: Bool = false) async throws {
        do {
            
            //let result = try await loyaltyAPIManager.getMemberProfile(for: memberId)
            let result = try await loyaltyAPIManager.getMemberProfile(for: memberId, devMode: devMode)
            
            profile = result
            // Save to local disk
            localFileManager.saveData(item: result, id: memberId, folderName: nil, expiry: .never)
        } catch {
            throw error
        }
    }
    
    func clear() {
        profile = nil
    }

}
