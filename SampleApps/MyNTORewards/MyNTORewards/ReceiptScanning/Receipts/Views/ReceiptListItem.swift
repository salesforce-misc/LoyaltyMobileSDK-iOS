//
//  ReceiptListItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptListItem: View {
	@StateObject private var receiptVM = ReceiptViewModel()
	let receiptNumber: String
	let receiptDate: String
	let amount: String?
	let points: String?

	let status: String
    var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Receipt \(receiptNumber)")
				Spacer()
				Text("\(amount ?? "0")")
			}
			.font(.transactionText )
			HStack {
                Text("Date \(receiptDate.toDateString() ?? "")")
				Spacer()
				if let points = points {
					Text("\(points) Points")
				} else {
					Text(status)
						.foregroundColor(receiptVM.getColor(for: status))
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
		ReceiptListItem(receiptNumber: "43456",
                        receiptDate: "2022-11-23T00:00:00.000+0000",
                        amount: "187000",
                        points: "500",
                        status: "Pending")
    }
}
