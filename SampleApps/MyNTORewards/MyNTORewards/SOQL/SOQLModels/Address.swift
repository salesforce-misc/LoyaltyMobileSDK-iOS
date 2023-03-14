/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public struct Address: Decodable {
    
    public enum GeocodeAccuracy: String, Decodable {
        case address = "Address"
        case nearAddress = "NearAddress"
        case block = "Block"
        case street = "Street"
        case extendedZip = "ExtendedZip"
        case zip = "Zip"
        case city = "Neighborhood"
        case county = "County"
        case state = "State"
        case unknown = "Unknown"
    }
    
    public let city: String?
    public let country: String?
    public let countryCode: String?
    public let geocodeAccuracy: GeocodeAccuracy?
    public let latitude: Double?
    public let longitude: Double?
    public let postalCode: String?
    public let state: String?
    public let stateCode: String?
    public let street: String?
}
