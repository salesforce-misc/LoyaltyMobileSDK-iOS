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
    
    /*
     Input:
     <p><img src=\"https://internalmobileteam-dev-ed.develop.file.force.com/servlet/rtaImage?eid=0kD4x000000wr6E&amp;feoid=00N4x00000YBPaQ&amp;refid=0EM4x00000443bE\" alt=\"Birthday.jpeg\"></img></p>
     attributeUrl: "/services/data/v56.0/sobjects/Voucher/0kD4x000000wx4WEAQ"
     fieldName: "Image__c"
     
     to: https://internalmobileteam-dev-ed.develop.file.force.com/servlet/rtaImage?eid=0kD4x000000wr6E&feoid=00N4x00000YBPaQ&refid=0EM4x00000443bE
     
     Output: https://internalmobileteam-dev-ed.develop.file.force.com/services/data/v56.0/sobjects/Voucher/0kD4x000000wx4WEAQ/richTextImageFields/Image__c/0EM4x00000443bE
     
     */
    static func getImageUrl(image: String?, attributesUrl: String, fieldName: String) -> String?  {
        
        guard let image = image else {
            return nil
        }
        
        let filteredArray = image.split(separator: " ").filter { item in
            item.contains("src")
        }
        
        if filteredArray.isEmpty {
            return nil
        } else {
            let srcString = filteredArray[0]
            let start = srcString.firstIndex(of: "h")!
            let urlString = String(srcString[start...].dropLast())
            
            let url = URL(string: urlString)
            guard let url = url else {
                return nil
            }
            guard let host = url.host else {
                return nil
            }
            
            let refStart = srcString.lastIndex(of: ";")!
            let refidString = String(srcString[refStart...].dropLast())
            let refid = refidString.split(separator: "=")[1]
            
            let imageUrl = "https://\(host)\(attributesUrl)/richTextImageFields/\(fieldName)/\(refid)"
            return imageUrl
        }
        
    }

}


