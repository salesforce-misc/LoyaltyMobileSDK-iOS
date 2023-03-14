//
//  ProductDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ProductDetailsView: View {
	@State private var sizeSelected = -1
	@State private var colorSelected = -1
	@State private var quantitySelected: Int = 1
	var body: some View {
		ScrollView(showsIndicators: false) {
			ZStack{
				Color(hex: "#F1F3FB")
				VStack {
					VStack {
						ProductHeaderView(title: "STOP", subTitle: "Women Flight Jacket", rating: 4)
						ProductImagesView(images: [
							"https://picsum.photos/620",
							"https://picsum.photos/532",
							"https://picsum.photos/456",
							"https://picsum.photos/879",
							"https://picsum.photos/805",
						])
					}
					SizeSelectorView(selection: $sizeSelected, sizes: ["S", "M", "L", "XL"])
					AvailableColorsView(selection: $colorSelected, colors: [.red, .green, .orange, .purple])
					HStack(alignment: .bottom) {
						QuantityView(quantitySelected: $quantitySelected, min: 1, max: 10)
						Spacer()
						VStack(alignment: .trailing) {
							Text("$\(quantitySelected * 179)")
								.font(.totalAmountText)
							Text("Free shipping")
								.font(.productShippingText)
						}
						.padding()
					}
					
					VStack {
						Button("Buy Now") {}
							.buttonStyle(DarkLongButton())
						Button("Add to Cart") {}
							.buttonStyle(LightLongPromotionButton())
					}
					.padding(.bottom, 100)
				}
			}
		}
		.edgesIgnoringSafeArea(.all)
	}
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView()
    }
}
