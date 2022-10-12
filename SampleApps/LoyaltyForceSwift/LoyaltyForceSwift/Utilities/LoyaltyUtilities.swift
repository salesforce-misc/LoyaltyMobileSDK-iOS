//
//  LoyaltyUtilities.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/11/22.
//

import Foundation
import UIKit

struct LoyaltyUtilities {

    static func getQRCodeData(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    static func generateQRCode(from string: String, color: UIColor = .black) -> Data? {
        
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            guard let colorFilter = CIFilter(name: "CIFalseColor") else {
                return nil
            }

            filter.setValue(data, forKey: "inputMessage")

            filter.setValue("H", forKey: "inputCorrectionLevel")
            colorFilter.setValue(filter.outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1") // Background white
            colorFilter.setValue(CIColor(color: color), forKey: "inputColor0") // Foreground or the barcode color

            let transform = CGAffineTransform(scaleX: 10, y: 10)


            if let output = colorFilter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output).pngData()!
            }
        }
        return nil
    }

}


