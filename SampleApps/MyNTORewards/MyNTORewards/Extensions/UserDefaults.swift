/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "com.salesforce.industries.mobile")!
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
