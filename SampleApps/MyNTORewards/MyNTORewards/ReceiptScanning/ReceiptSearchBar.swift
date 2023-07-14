//
//  ReceiptSearchBar.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptSearchBar: View {
	@State var fieldValue: String = ""
    var body: some View {
		HStack {
			Image(systemName: "magnifyingglass").foregroundColor(.gray)
			TextField("Search for Receipt number", text: $fieldValue)
				.font(.receiptSearchText)
		}
		.padding()
		.background(Color.theme.searchBarBackgroundColor)
		.cornerRadius(12)
    }
}

struct ReceiptSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptSearchBar()
    }
}
