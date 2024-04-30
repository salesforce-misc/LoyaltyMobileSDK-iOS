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
	func getImage(url: String, defaultImage: UIImage? = nil, reload: Bool = false) async {
        let urlHash = url.MD5
        if images[urlHash] == nil || reload {
            if let cached = LocalFileManager.instance.getImage(imageName: urlHash), !reload {
				Logger.debug("Updating from Cache \(url)")
                images[urlHash] = cached
            } else {
                if let fetchedImage = await forceClient.fetchImage(url: url) {
                    LocalFileManager.instance.saveImage(image: fetchedImage, imageName: urlHash)
                    images[urlHash] = fetchedImage
					Logger.debug("Fetched from API and saved locally \(url)")
				} else if let defaultImage = defaultImage {
					LocalFileManager.instance.saveImage(image: defaultImage, imageName: urlHash)
					images[urlHash] = defaultImage
					Logger.debug("using default and saved locally \(url)")
				} else {
					print("inner else condition \(url)")
				}
            }
		} else {
			print("else condition")
		}
    }
    
    @MainActor
    func clear() {
        images = [:]
    }
}
