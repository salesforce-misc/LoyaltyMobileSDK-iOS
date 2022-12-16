//
//  UserDefaults.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/13/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "com.salesforce.loyalty.mobile")!
    }
    
    var userIdentifier: ForceUserIdentifier? {
        get {
            return string(forKey: #function)
        }
        set {
            guard let user = newValue else {
                return removeObject(forKey: #function)
            }
            set(user, forKey: #function)
        }
    }
}
