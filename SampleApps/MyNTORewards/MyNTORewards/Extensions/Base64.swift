//
//  Base64.swift
//  MyNTORewards
//
//  Created by Leon Qi on 8/16/23.
//

import UIKit

// UIImage extension to convert image to Base64 string
extension UIImage {
    func base64String() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}

// String extension to convert Base64 string to UIImage
extension String {
    func base64ToImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
