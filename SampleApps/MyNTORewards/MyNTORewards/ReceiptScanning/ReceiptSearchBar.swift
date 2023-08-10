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
		HStack {
			Image(systemName: "magnifyingglass").foregroundColor(.gray)
			TextField("Search receipts...", text: $fieldValue)
				.font(.receiptSearchText)
				.accessibilityIdentifier(AppAccessibilty.receipts.searchBar)
		}
		.padding()
		.background(Color.theme.searchBarBackgroundColor)
		.cornerRadius(12)
    }
}

struct ReceiptSearchBar_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptSearchBar(fieldValue: .constant("675"))
    }
}
