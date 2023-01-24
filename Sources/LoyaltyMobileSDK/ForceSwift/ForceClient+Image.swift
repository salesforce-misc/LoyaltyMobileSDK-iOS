//
//  ForceClient+Image.swift
//  LoyaltyMobileSDK
//
//  Created by Leon Qi on 12/22/22.
//

import Foundation
import UIKit

extension ForceClient {
    
    public func fetchImage(url: String?) async -> UIImage? {
        
        guard let url = url,
              let imageUrl = URL(string: url) else {
            return nil
        }

        do {
            let request = try ForceRequest.create(url: imageUrl, method: "GET", secured: true)
            let output = try await URLSession.shared.data(for: request)
            try handleUnauthResponse(output: output)
            return handleImageResponse(output: output)
        } catch ForceError.authenticationNeeded {
            do {
                let request = try ForceRequest.create(url: imageUrl, method: "GET", secured: true)
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
