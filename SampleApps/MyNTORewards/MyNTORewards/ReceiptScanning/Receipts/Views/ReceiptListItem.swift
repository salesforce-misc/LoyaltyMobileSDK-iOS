//
//  ReceiptListItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptListItem: View {
	@StateObject private var receiptVM = ReceiptViewModel()
	let receipt: Receipt

    var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Receipt \(receipt.receiptId ?? "-")")
				Spacer()
				Text("\(receipt.totalAmount ?? "0")")
			}
			.font(.transactionText )
			HStack {
				Text("Date \(receipt.purchaseDate?.toDateString() ?? " - "    )")

				Spacer()
				if let points = receipt.totalPoints {
					Text("\(points) Points")
				} else {
					Text(receipt.status ?? "-")
						.foregroundColor(receiptVM.getColor(for: receipt.status ?? "-"))
				}
			}
			.font(.transactionDate)
		}
		.padding()
		.background(.white)
		.cornerRadius(8)
		.listRowBackground(Color.theme.background)
		.shadow(color: Color.theme.receiptListItemShadowColor, radius: 5, x: 0, y: 6.69268)
    }
}

struct ReceiptListItem_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptListItem(receipt: Receipt())
    }
}
