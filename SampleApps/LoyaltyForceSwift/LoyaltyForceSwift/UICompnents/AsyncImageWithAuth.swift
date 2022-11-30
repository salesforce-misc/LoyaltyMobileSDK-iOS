//
//  AsyncImageWithAuth.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/30/22.
//

import SwiftUI

struct AsyncImageWithAuth<Content: View, Placeholder: View>: View {
    
    @State var uiImage: UIImage?
    
    let url: String?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(url: String?,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        
        if let url = url {
            if let uiImage = uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .task {
                        // use it for file name
                        let urlHash = url.MD5
                        // try to get from cache first
                        if let image = LocalFileManager.instance.getImage(imageName: urlHash) {
                            self.uiImage = image
                        } else {
                            let fetchedImage = await ForceClient.shared.fetchImage(url: url)
                            self.uiImage = fetchedImage
                            // save to local cache
                            if let image = fetchedImage {
                                LocalFileManager.instance.saveImage(image: image, imageName: urlHash)
                            }
                        }
                    }
            }
        } else {
            Image("img-placeholder")
        }
        
        
    }
}



struct AsyncImageWithAuth_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageWithAuth(url: "https://internalmobileteam-dev-ed.develop.file.force.com/services/data/v56.0/sobjects/Voucher/0kD4x000000wr6EEAQ/richTextImageFields/Image__c/0EM4x00000443bE") { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
        } placeholder: {
            ProgressView()
        }

    }
}
