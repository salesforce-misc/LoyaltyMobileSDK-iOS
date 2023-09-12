//
//  ReceiptSearchBar.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptSearchBar: View {
	@Binding var fieldValue: String
    var body: some View {
		HStack(spacing: 4) {
			Image(systemName: "magnifyingglass").foregroundColor(.gray)
			TextField(StringConstants.Receipts.searchPlaceholder, text: $fieldValue)
				.font(.receiptSearchText)
				.accessibilityIdentifier(AppAccessibilty.receipts.searchBar)
			if !fieldValue.isEmpty {
				Button {
					fieldValue = ""
				} label: {
					Image(systemName: "xmark.circle").foregroundColor(.gray)
				}
			}
		}
		.padding(.horizontal, 8)
		.padding(.vertical)
		.background(Color.theme.searchBarBackgroundColor)
		.cornerRadius(12)
    }
}

struct ReceiptSearchBar_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptSearchBar(fieldValue: .constant("675"))
    }
}
