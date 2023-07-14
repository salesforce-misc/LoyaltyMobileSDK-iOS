//
//  ReceiptsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptsView: View {
	var body: some View {
		VStack(spacing: 4) {
			HStack(spacing: 8) {
				ReceiptSearchBar()
					.padding(.leading)
				Button {
					print("new tapped")
				} label: {
					Text("New")
						.font(.boldButtonText)
						.longFlexibleButtonStyle()
						.frame(width: 120)
				}
				.frame(width: 81, height: 48)
				.padding(.horizontal, 16)
				.padding(.vertical, 4)
			}
			ReceiptList()
		}
		.background(Color.theme.background)
	}
}

struct ReceiptsView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptsView()
    }
}
