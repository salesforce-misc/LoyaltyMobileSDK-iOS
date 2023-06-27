//
//  ForceRequest+Auth.swift
//  MyNTORewards
//
//  Created by Leon Qi on 3/23/23.
//

import Foundation
import LoyaltyMobileSDK

extension ForceRequest {
    
    static func updateRequestWithSavedAuth(for request: URLRequest) throws -> URLRequest {

        do {
            let auth = try ForceAuthManager.shared.retrieveAuth()
            return setAuthorization(request: request, accessToken: auth.accessToken)
        } catch {
            throw error
        }

    }
}
