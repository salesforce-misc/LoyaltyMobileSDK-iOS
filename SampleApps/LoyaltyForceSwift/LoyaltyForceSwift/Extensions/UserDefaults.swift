//
//  UserDefaults.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 9/13/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "mobile.loyalty.salesfoce.com")!
    }
    
    var userIdentifier: ForceUserIdentifier? {
        get {
            return #function
        }
        set {
            guard let user = newValue else {
                return removeObject(forKey: #function)
            }
            set(user, forKey: #function)
        }
    }
}
