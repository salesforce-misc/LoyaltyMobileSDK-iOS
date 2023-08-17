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
		ForEach(items) { item in
			ReceiptTableContentRow(itemName: item.itemName,
								   qty: item.quantity,
								   price: item.price,
								   total: item.total)
			.listRowSeparator(.hidden)
			.padding(0.5)
		}
		.font(.receiptItemsFont)
		.listStyle(.plain)
	}
}

struct ProcessedReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ProcessedReceiptList(items: [ProcessedReceiptItem(itemName: "Converse Shoes", quantity: 1, price: 599, total: 599)
									])
    }
}
