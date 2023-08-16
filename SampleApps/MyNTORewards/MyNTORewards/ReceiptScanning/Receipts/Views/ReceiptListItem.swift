//
//  ReceiptListItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptListItem: View {
	let receiptNumber: String
	let receiptDate: String
	let amount: Double
	let points: Double
	let currency: String
    var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("Receipt \(receiptNumber)")
				Spacer()
				Text("\(currency) \(amount, specifier: "%.0f")")
			}
			.font(.transactionText )
			HStack {
				Text("Date \(receiptDate.toDateString() ?? "")")
				Spacer()
				Text("\(points, specifier: "%.0f") Points")
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
		ReceiptListItem(receiptNumber: "43456", receiptDate: "13/07/2023", amount: 187000, points: 500, currency: "INR")
    }
}
