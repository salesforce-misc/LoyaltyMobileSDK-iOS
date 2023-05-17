//
//  AsyncImageWithAuth.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/30/22.
//

import SwiftUI

struct LoyaltyAsyncImage<Content: View, Placeholder: View>: View {
    
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
        if let url = url, let image = imageVM.images[url.MD5] {
            content(Image(uiImage: image))
        } else if let url = url {
            placeholder().task { await imageVM.getImage(url: url) }
        } else {
            Image("img-placeholder")
        }
    }
}

struct AsyncImageWithAuth_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable line_length
        LoyaltyAsyncImage(url: "https://unsplash.com/photos/CDLBz2lPpLM/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8NDR8fHdpbnRlciUyMGphY2tldHN8ZW58MHx8fHwxNjg0Mjg4OTU2fDA&force=true&w=640") { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
        } placeholder: {
            ProgressView()
        }
        .environmentObject(dev.imageVM)
        // swiftlint:enable line_length
    }
}
