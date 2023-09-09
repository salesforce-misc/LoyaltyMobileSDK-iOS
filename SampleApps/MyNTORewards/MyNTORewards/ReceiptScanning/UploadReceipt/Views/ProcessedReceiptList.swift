//
//  ProcessedReceiptList.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ProcessedReceiptList: View {
	var items: [ProcessedReceiptItem]
	var body: some View {
		ForEach(items, id: \.self) { item in
			ReceiptTableContentRow(itemName: item.productName,
								   qty: item.quantity,
								   price: item.price ?? "",
								   total: item.lineItemPrice ?? "")
			.listRowSeparator(.hidden)
			.padding(0.5)
		}
		.font(.receiptItemsFont)
		.listStyle(.plain)
	}
}

struct ProcessedReceiptList_Previews: PreviewProvider {
	static var previews: some View {
		ProcessedReceiptList(items: [ProcessedReceiptItem(quantity: "1", productName: "Converse Shoes", price: "$599", lineItemPrice: "$599")])
	}
}
