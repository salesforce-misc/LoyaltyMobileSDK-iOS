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
    
//    @Published var referrals: [Record] = []
//    private let authManager: ForceAuthenticator
//    private var forceClient: ForceClient
//    
//    init(
//        authManager: ForceAuthenticator = ForceAuthManager.shared,
//        forceClient: ForceClient? = nil
//    ) {
//        self.authManager = authManager
//        self.forceClient = forceClient ?? ForceClient(auth: authManager)
//    }
//    
//    
//    func getAllReferrals() -> [Record] {
//        let query = "SELECT ReferrerId, Id, ClientEmail, ReferrerEmail, ReferralDate, CurrentPromotionStage.Type FROM Referral WHERE ReferralDate = LAST_90_DAYS ORDER BY ReferralDate DESC"
//        
//        do {
//            let queryResult = try await ForceClient.SOQL(type: Receipt.self, for: query)
//            return queryResult.records
//        } catch {
//            Logger.error(error.localizedDescription)
//            throw error
//        }
//    }
}
