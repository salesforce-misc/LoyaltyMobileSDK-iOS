//
//  ForceRequest+PercentEncoding.swift
//  MyNTORewards
//
//  Created by Leon Qi on 6/2/23.
//

import Foundation
import LoyaltyMobileSDK

extension ForceRequest {
    public static func percentEncodedFormData(_ parameters: [String: String]) throws -> Data {
        let parameterArray = try parameters.map { key, value in
            var encodedValue: String
            if key == "username" || key == "email" {
                // Remove `+` from the allowed list which will allow it to be encoded to `%2B`
                // Otherwise, `+` will be retained and later on it will be interpreted as a space
                var customSet = CharacterSet.urlQueryAllowed
                customSet.remove("+")

                guard let encoded = value.addingPercentEncoding(withAllowedCharacters: customSet) else {
                    throw CommonError.urlEncodingFailed
                }
                encodedValue = encoded
            } else {
                guard let encoded = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    throw CommonError.urlEncodingFailed
                }
                encodedValue = encoded
            }
            return "\(key)=\(encodedValue)"
        }
        let parameterString = parameterArray.joined(separator: "&")
        guard let body = parameterString.data(using: .utf8) else {
            throw CommonError.urlEncodingFailed
        }
        return body
    }
}
