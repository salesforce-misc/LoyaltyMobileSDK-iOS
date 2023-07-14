//
//  ReceiptsView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/12/23.
//

import SwiftUI
import UIKit

struct ReceiptsView: View {
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Button("Open Camera") {
                self.showCamera = true
            }
            Image(uiImage: inputImage ?? UIImage())
                .resizable()
                .scaledToFit()
        }
        .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
                .ignoresSafeArea()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        // handle the image
    }
}

struct ReceiptsView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptsView()
    }
}
