//
//  ProcessedReceiptListWithHeader.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 29/08/23.
//

import SwiftUI

struct ProcessedReceiptListWithHeader: View {
	var processedAwsResponse: ProcessedAwsResponse
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
				ProcessedReceiptList(items: processedAwsResponse.lineItem)
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
		ProcessedReceiptListWithHeader(processedAwsResponse: ProcessedAwsResponse(totalAmount: "$599",
																				  storeName: "Costco",
																				  storeAddress: "Palo Alto",
																				  receiptNumber: "R-9867",
																				  receiptDate: "12/30/2022",
																				  memberShipNumber: "34523443",
																				  lineItem: [LineItem(quantity: "1",
																									  productName: "Converse shoes",
																									  price: "$599",
																									  lineItemPrice: "$599")]
																				 ))
	}
}
