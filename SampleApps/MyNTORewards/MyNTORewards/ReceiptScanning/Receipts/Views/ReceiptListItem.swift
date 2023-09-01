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
	let receiptDate: Date
	let amount: String?
	let points: String?
	let currency: String
	let status: String
    var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Receipt \(receiptNumber)")
				Spacer()
				Text("\(currency) \(amount ?? "")")
			}
			.font(.transactionText )
			HStack {
                Text("Date \(receiptDate.toString(withFormat: "YYYY-MM-DDTHH:MM:SS.sssZ"))")
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
                        receiptDate: "2019-11-02T00:00:00.000+0000".toDate(withFormat: "YYYY-MM-DDTHH:MM:SS.sssZ") ?? Date(),
                        amount: "187000",
                        points: "500",
                        currency: "INR",
                        status: "Pending")
    }
}
