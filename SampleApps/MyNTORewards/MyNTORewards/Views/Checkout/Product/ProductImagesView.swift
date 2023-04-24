//
//  ProductImagesView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct ProductImagesView: View {
	@State private var selectedImageURL: String = ""
	var images: [String]
	
    var body: some View {
		VStack {
			AsyncImageView(imageUrl: selectedImageURL)
				.scaledToFit()
				.padding(16)
				ScrollView(.horizontal, showsIndicators: false) {
					LazyHStack {
						ForEach(images, id: \.self) {image in
							AsyncImageView(imageUrl: image)
								.scaledToFit()
								.frame(width: 92, height: 92)
								.onTapGesture {
									selectedImageURL = image
								}
						}
					}
				}
				.frame(height: 100)
		}
		.onAppear {
			selectedImageURL = images.first ?? " "
		}
    }
}

struct ProductImagesView_Previews: PreviewProvider {
    static var previews: some View {
		ProductImagesView(images: [
			"https://picsum.photos/186",
			"https://picsum.photos/187",
			"https://picsum.photos/190",
			"https://picsum.photos/130",
			"https://picsum.photos/215"
		])
    }
}
