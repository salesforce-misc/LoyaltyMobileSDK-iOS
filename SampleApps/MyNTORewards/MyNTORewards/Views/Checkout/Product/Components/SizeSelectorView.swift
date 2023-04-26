//
//  SizeSelectorView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 09/03/23.
//

import SwiftUI

struct SizeSelectorView: View {
	@State private var selectedIndex = -1
	@Binding var selection: Int
	var sizes: [String]
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Select size")
					.font(.selectionTitleText)
				Spacer()
				Button {
					print("Image tapped!")
				} label: {
					Text("View Size Chart")
						.font(.selectionTitleText)
				}
			}
			HStack(spacing: 12) {
				ForEach(0..<sizes.count, id: \.self) { i in
					SizeView(size: sizes[i], isSelected: i == selectedIndex)
						.frame(width: 43, height: 36)
						.onTapGesture {
							selectedIndex = i
							selection = i
						}
				}
			}
		}
		.padding()
    }
}

struct SizeSelectorView_Previews: PreviewProvider {
    static var previews: some View {
		SizeSelectorView(selection: .constant(-1), sizes: ["S", "M", "L", "XL", "XXL"])
    }
}

struct SizeView: View {
	var size: String
	var isSelected: Bool = false
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(isSelected ? Color.black : Color.clear)
				.overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke())
			Text(size)
				.font(.productQuantityText)
				.foregroundColor(isSelected ? Color.white : Color.black)
		}
	}
}
