//
//  Connection.swift
//  LoyaltyStarter
//
//  Created by Leon Qi on 8/30/22.
//

import Foundation
import SwiftlySalesforce

class NetworkManager {
    
    static var connection = try! Salesforce.connect()
}
