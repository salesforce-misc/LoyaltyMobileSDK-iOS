//
//  ProductDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct ProductDetailsView: View {
	@State private var sizeSelected = 0
	@State private var colorSelected = 0
	@State private var quantitySelected: Int = 1
	var body: some View {
		ScrollView(showsIndicators: false) {
			ZStack {
				Color(hex: "#F1F3FB")
				VStack {
					VStack {
						ProductHeaderView(title: "STOP", subTitle: "Women Flight Jacket", rating: 4)
						ProductImagesView(mainImage: "img-product1",
										  subImages: [
											"img-product2",
											"img-product3",
											"img-product4",
											"img-product5"
										  ])
					}
					SizeSelectorView(selection: $sizeSelected, sizes: ["S", "M", "L", "XL"])
					AvailableColorsView(selection: $colorSelected, colors: [Color("VibrantRed"), Color("ProductGreen"), Color("ProductPeach"), Color("VibrantPurple")])
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
				}
			}
			.padding(.top, 16)
		}
	}
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView()
    }
}
