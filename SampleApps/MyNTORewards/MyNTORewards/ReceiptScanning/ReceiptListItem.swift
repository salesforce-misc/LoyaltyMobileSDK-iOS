//
//  ReceiptListItem.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI

struct ReceiptListItem: View {
	let receiptNumber: Int
	let receiptDate: String
	let amount: Int
	let points: Int
	let currency: String
    var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("\(receiptNumber)")
				Spacer()
				Text("\(currency) \(amount)")
			}
			.font(.transactionText )
			HStack {
				Text("\(receiptDate)")
				Spacer()
				Text("\(points) Points")
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
		ReceiptListItem(receiptNumber: 43456, receiptDate: "13/07/2023", amount: 187000, points: 500, currency: "INR")
    }
}
