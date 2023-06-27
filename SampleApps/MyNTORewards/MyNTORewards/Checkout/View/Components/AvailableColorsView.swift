//
//  AvailableColorsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI

struct AvailableColorsView: View {
	@State private var selectedIndex = 0
	@Binding var selection: Int
	var colors: [Color]
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Available Colors")
					.font(.selectionTitleText)
				Spacer()
			}
			HStack(spacing: 12) {
				ForEach(0..<colors.count, id: \.self) { i in
					ColorView(color: colors[i], isSelected: i == selectedIndex)
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

struct AvailableColorsView_Previews: PreviewProvider {
    static var previews: some View {
		AvailableColorsView(selection: .constant(-1), colors: [.red, .green, .orange, .mint])
    }
}

struct ColorView: View {
	var color: Color
	var isSelected: Bool = false
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(color)
				.overlay(isSelected ? RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.black, lineWidth: 1) : nil)
		}
	}
}
