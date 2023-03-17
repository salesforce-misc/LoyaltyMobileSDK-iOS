/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

import Foundation
import UIKit

extension ForceClient {
    
    public func fetchImage(url: String?) async -> UIImage? {
        
        guard let url = url,
              let imageUrl = URL(string: url) else {
            return nil
        }

        do {
            let request = ForceRequest.createRequest(from: imageUrl, method: "GET")
            let output = try await URLSession.shared.data(for: request)
            try handleUnauthResponse(output: output)
            return handleImageResponse(output: output)
        } catch ForceError.authenticationNeeded {
            do {
                let request = ForceRequest.createRequest(from: imageUrl, method: "GET")
                let newRequet = try await getNewRequest(for: request)
                let output = try await URLSession.shared.data(for: newRequet)
                try handleUnauthResponse(output: output)
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
