//
//  ReceiptTableContentRow.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ReceiptTableContentRow: View {
	var itemName: String
	var qty: String
	var price: String
	var total: String
	var body: some View {
		HStack {
			Text("\(itemName)")
				.productNameFrame()
			Spacer()
				.productQuantitySpaceFrame()
			Text("\(qty)")
				.quantityFrame()
			Spacer()
			Text("\(price)")
				.priceFrame()
			Spacer()
			Text("$\(total)")
				.totalPriceFrame()
		}
		.padding(.horizontal)
	}
}

struct ReceiptTableContentRow_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptTableContentRow(itemName: "Converse Shoes", qty: "1", price: "$599", total: "$599")
    }
}
