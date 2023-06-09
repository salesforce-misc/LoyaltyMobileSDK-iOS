//
//  ImageViewModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 12/3/22.
//

import Foundation
import SwiftUI
import LoyaltyMobileSDK

class ImageViewModel: ObservableObject {

    @Published var images: [String: UIImage] = [:]
    private let authManager = ForceAuthManager.shared
    private var forceClient: ForceClient
    
    init() {
        forceClient = ForceClient(auth: authManager)
    }

    @MainActor
    func getImage(url: String) async {
        let urlHash = url.MD5
        if images[urlHash] == nil {
            if let cached = LocalFileManager.instance.getImage(imageName: urlHash) {
                images[urlHash] = cached
            } else {
                if let fetchedImage = await forceClient.fetchImage(url: url) {
                    LocalFileManager.instance.saveImage(image: fetchedImage, imageName: urlHash)
                    images[urlHash] = fetchedImage
                }
            }
        }
    }
    
    @MainActor
    func clear() {
        images = [:]
    }
}
