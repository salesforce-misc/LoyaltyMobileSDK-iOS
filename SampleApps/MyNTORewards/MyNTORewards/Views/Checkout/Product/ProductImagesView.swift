//
//  ProductImagesView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct ProductAsyncImagesView: View {
	@State private var selectedImageURL: String = ""
	var images: [String]
	
    var body: some View {
		VStack {
			AsyncImageView(imageUrl: selectedImageURL)
				.cornerRadius(10, corners: .allCorners)
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

struct ProductImagesView: View {
	var mainImage: String
	var subImages: [String]
	
	var body: some View {
		VStack {
			Image(mainImage)
				.cornerRadius(10, corners: .allCorners)
				.scaledToFit()
				.padding(16)
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack {
					ForEach(subImages, id: \.self) {image in
						Image(image)
							.scaledToFit()
							.frame(width: 92, height: 92)
					}
				}
			}
			.frame(height: 100)
		}
	}
}

struct ProductImagesView_Previews: PreviewProvider {
    static var previews: some View {
		ProductImagesView(mainImage: "img-product1",
						  subImages: [
							"img-product2",
							"img-product3",
							"img-product4",
							"img-product5"
						  ])
    }
}
