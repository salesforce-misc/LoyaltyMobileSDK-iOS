/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import UIKit

public extension ForceClient {
    
    
    /// Fetch an image
    /// - Parameters:
    ///   - url: The URL of the image
    /// - Returns: An ``UIImage`` if successful or ``nil`` otherwise
    func fetchImage(url: String?) async -> UIImage? {
        
        guard let url = url,
              let imageUrl = URL(string: url) else {
            return nil
        }

        do {
            let request = try ForceRequest.create(url: imageUrl, method: "GET")
            let output = try await URLSession.shared.data(for: request)
            try ForceNetworkManager.shared.handleUnauthResponse(output: output)
            return handleImageResponse(output: output)
        } catch ForceError.authenticationNeeded {
            do {
                let request = try ForceRequest.create(url: imageUrl, method: "GET")
                let token = try await auth.grantAccessToken()
                let newRequet = ForceRequest.setAuthorization(request: request, accessToken: token)
                let output = try await URLSession.shared.data(for: newRequet)
                return handleImageResponse(output: output)
            } catch {
                return nil
            }
            
        } catch {
            return nil
        }
    }
    
    private func handleImageResponse(output: URLSession.DataTaskPublisher.Output) -> UIImage? {
        guard
            let image = UIImage(data: output.data),
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
            }
        return image
    }
}
