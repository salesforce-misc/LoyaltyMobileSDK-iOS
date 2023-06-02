/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation

public struct ForceConnectedApp: Codable, Hashable {
    public let connectedAppName: String
    public let consumerKey: String
    public let consumerSecret: String
    public let callbackURL: String
    public let baseURL: String
    public let instanceURL: String
    public let communityURL: String
    public let selfRegisterURL: String
}
