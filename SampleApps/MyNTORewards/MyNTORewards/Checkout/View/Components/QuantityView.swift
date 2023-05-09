//
//  QuantityView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct QuantityView: View {
	@State private var quantity: Int
	@Binding var quantitySelected: Int
	var min: Int
	var max: Int
	
	init(quantitySelected: Binding<Int>, min: Int, max: Int) {
		self._quantitySelected = quantitySelected
		self.min = min > 0 ? min : 1
		self.max = max
		quantity = min
	}
	var body: some View {
		VStack(alignment: .leading) {
			Text("Quantity")
				.font(.selectionTitleText)
			ZStack {
				HStack(spacing: 16) {
					StepperButtonView(title: "-", {
						quantity -= quantity > min ? 1 : 0
						quantitySelected = quantity
					})
						.frame(width: 43, height: 36)
						.padding(.trailing, 36)
					StepperButtonView(title: "+", {
						quantity += quantity < max ? 1 : 0
						quantitySelected = quantity
					})
						.frame(width: 43, height: 36)
				}
				Text("\(quantity)")
			}
		}
		.padding()
	}
}

struct StepperButtonView: View {
	var action: () -> Void
	let title: String
	init(title: String, _ action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.stroke()
			Text(title)
				.font(.custom("Archivo-SemiBold", size: 16))
		}.onTapGesture {
			action()
		}
	}
}

struct QuantityView_Previews: PreviewProvider {
    static var previews: some View {
		QuantityView(quantitySelected: .constant(1), min: 5, max: 10)
    }
}
