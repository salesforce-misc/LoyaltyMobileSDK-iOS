//
//  ImageViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 12/3/22.
//

import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {

    @Published var images: [String: UIImage] = [:]

    @MainActor
    func getImage(url: String) async {

        let urlHash = url.MD5
        if images[urlHash] == nil {
            if let cached = LocalFileManager.instance.getImage(imageName: urlHash) {
                images[urlHash] = cached
            } else {
                let fetchedImage = await ForceClient.shared.fetchImage(url: url)
                // save to local cache
                if let image = fetchedImage {
                    LocalFileManager.instance.saveImage(image: image, imageName: urlHash)
                    images[urlHash] = image
                } else {
                    images[urlHash] = UIImage(named: "img-placeholder")
                }
            }
        }
    }
    
    @MainActor
    func clear() {
        images = [:]
    }
}
