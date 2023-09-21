//
//  ProcessedReceiptListWithHeader.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 29/08/23.
//

import SwiftUI

struct ProcessedReceiptList: View {
	var eligibleItems: [ProcessedReceiptItem] = []
	var inEligibleItems: [ProcessedReceiptItem] = []
	private let eligibleItemsTitle = "Eligible Items found in the receipt"
	private let inEligibleItemsTitle = "Non Eligible Items found in the receipt"
	
	var body: some View {
		VStack {
			ScrollView {
				space
				if !eligibleItems.isEmpty {
					table(items: eligibleItems, title: eligibleItemsTitle)
				}
				space
				if !inEligibleItems.isEmpty  {
					table(items: inEligibleItems, title: inEligibleItemsTitle)
				}
				space
			}
			.frame(maxHeight: .infinity)
		}
		.background(.white)
		.cornerRadius(4)
	}
	
	private func table(items: [ProcessedReceiptItem], title: String) -> some View {
		VStack(alignment: .leading) {
			Text(title)
				.padding(.horizontal)
			VStack {
				dottedLine
				ProcessedReceiptListTitle()
					.font(.receiptItemsTitleFont)
				dottedLine
				ProcessedReceiptListContent(items: items)
				dottedLine
			}
			.padding(.horizontal, 8)
		}
	}
	
	private var dottedLine: some View {
		Rectangle()
			.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
			.frame(height: 1)
			.padding(10)
	}
	
	private var space: some View {
		Spacer()
			.frame(height: 25)
	}
}

struct ProcessedReceiptList_Previews: PreviewProvider {
	static var previews: some View {
		ProcessedReceiptList(eligibleItems: [ProcessedReceiptItem(quantity: "1",
																  productName: "Converse shoes",
																  price: "$599",
																  lineItemPrice: "$599", isEligible: true)],
							 inEligibleItems: [ProcessedReceiptItem(quantity: "1",
																	productName: "Converse shoes",
																	price: "$599",
																	lineItemPrice: "$599", isEligible: true)]
		)
		ProcessedReceiptList(eligibleItems: [ProcessedReceiptItem(quantity: "1",
																  productName: "Converse shoes",
																  price: "$599",
																  lineItemPrice: "$599", isEligible: true)]
		)
		ProcessedReceiptList(inEligibleItems: [ProcessedReceiptItem(quantity: "1",
																	productName: "Converse shoes",
																	price: "$599",
																	lineItemPrice: "$599", isEligible: true)]
		)
	}
}
