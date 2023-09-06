//
//  ProcessedReceiptListWithHeader.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 29/08/23.
//

import SwiftUI

struct ProcessedReceiptListWithHeader: View {
	var processedListItems: [ProcessedReceiptItem]
	var body: some View {
		VStack(spacing: 0) {
			Rectangle()
				.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
				.frame(height: 1)
				.padding()
			
			ReceiptTableTitleRow()
				.font(.receiptItemsTitleFont)
			Rectangle()
				.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
				.frame(height: 1)
				.padding()
			ScrollView {
				ProcessedReceiptList(items: processedListItems)
				Rectangle()
					.strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
					.frame(height: 1)
					.padding()
			}
			.frame(maxHeight: .infinity)
		}
		.background(.white)
		.cornerRadius(4)
	}
}

struct ProcessedReceiptListWithHeader_Previews: PreviewProvider {
    static var previews: some View {
		ProcessedReceiptListWithHeader(processedListItems: [ProcessedReceiptItem(quantity: "3",
                                                                                 productName: "sample product",
                                                                                 price: "4000",
                                                                                 lineItemPrice: "12000")])
    }
}
