//
//  LoyaltyAPIManager.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/15/22.
//
// https://salesforce.quip.com/3NUAATucFfLU#temp:C:aJadb5bff3175a74eba9461c7d9a

import Foundation

public struct LoyaltyAPIManager {
    
    public enum Resource {
        case individualEnrollment(programName: String)
        case getMemberBenefits(memberId: String)
        case getMemberProfile(programName: String)
        case getTransactions(programName: String)
        case getPromotions(programName: String, programProcessName: String)
        case redeemPoints(programName: String, programProcessName: String)
    }
    
    public static func getPath(for resource: Resource) -> String {
        
        switch resource {
        case .individualEnrollment(let programName):
            return "connect/loyalty-programs/\(programName)/individual-member-enrollments"
        case .getMemberBenefits(let memberId):
            return "connect/loyalty/member/\(memberId)/memberbenefits"
        case .getMemberProfile(let programName):
            return "loyalty-programs/\(programName)/members"
        case .getTransactions(let programName):
            return "connect/loyalty/programs/\(programName)/transaction-history" // ?page=1 Will deal with it later
        case .getPromotions(let programName, let programProcessName):
            return "connect/loyalty/programs/\(programName)/program-processes/\(programProcessName)"
        case .redeemPoints(let programName, let programProcessName):
            return "connect/loyalty/programs/\(programName)/program-processes/\(programProcessName)"
        }
    }
}
