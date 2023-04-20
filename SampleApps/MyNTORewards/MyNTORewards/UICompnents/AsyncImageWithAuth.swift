//
//  AsyncImageWithAuth.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/30/22.
//

import SwiftUI

struct AsyncImageWithAuth<Content: View, Placeholder: View>: View {
    
    @EnvironmentObject private var imageVM: ImageViewModel
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
            let urlHash = url.MD5
            if let uiImage = imageVM.images[urlHash] {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .task {
                        await imageVM.getImage(url: url)
                    }
            }
        } else {
            Image("img-placeholder")
        }
    }
}

struct AsyncImageWithAuth_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable line_length
        AsyncImageWithAuth(url: "https://internalmobileteam-dev-ed.develop.file.force.com/services/data/v56.0/sobjects/Voucher/0kD4x000000wr6EEAQ/richTextImageFields/Image__c/0EM4x00000443bE") { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
        } placeholder: {
            ProgressView()
        }
        // swiftlint:enable line_length

    }
}
