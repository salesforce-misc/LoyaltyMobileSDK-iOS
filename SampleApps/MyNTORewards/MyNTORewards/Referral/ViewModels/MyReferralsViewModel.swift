//
//  MyReferralsViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/20/23.
//

import Foundation
import SwiftUI
import ReferralMobileSDK

@MainActor
class MyReferralsViewModel: ObservableObject {
    
    @Published var referrals: [Record] = []
    private let authManager: ForceAuthenticator
    private var forceClient: ForceClient
    
    let defaultPromotionCode = "TESTRM"
    
    init(
        authManager: ForceAuthenticator = ForceAuthManager.shared,
        forceClient: ForceClient? = nil
    ) {
        self.authManager = authManager
        self.forceClient = forceClient ?? ForceClient(auth: authManager)
    }
    
    func getAllReferrals() async throws -> [Referral] {
        // swiftlint:disable:next line_length
        let query = "SELECT ReferrerId, Id, ClientEmail, ReferrerEmail, ReferralDate, CurrentPromotionStage.Type FROM Referral WHERE ReferralDate = LAST_90_DAYS ORDER BY ReferralDate DESC"
        
        do {
            let queryResult = try await forceClient.SOQL(type: Referral.self, for: query)
            return queryResult.records
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
    
    func getReferralCode(for membershipNumber: String) async throws -> String? {
        let query = "SELECT Id, ReferralCode FROM LoyaltyProgramMember WHERE MembershipNumber = '\(membershipNumber)'"
        
        do {
            let queryResult = try await forceClient.SOQL(type: Record.self, for: query)
            let referral = queryResult.records.first
            return referral?.string(forField: "ReferralCode")
        } catch {
            Logger.error(error.localizedDescription)
            throw error
        }
    }
    
}
