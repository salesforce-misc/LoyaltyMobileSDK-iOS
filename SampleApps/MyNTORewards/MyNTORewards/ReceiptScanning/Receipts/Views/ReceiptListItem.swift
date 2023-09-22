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
				Text("Receipt \(receipt.receiptId)")
				Spacer()
				Text("\(receipt.totalAmount ?? "0")")
			}
			.font(.transactionText )
			HStack {
				Text("Date \(receipt.purchaseDate.toDateString() ?? " - ")")

				Spacer()
				
                if receipt.status == "Processed" {
                    Text("\(receipt.totalPoints?.truncate(to: 2) ?? "0") Points").foregroundColor(Color("PointsColor"))
                } else {
                    Text(receipt.status == "Manual Review" ? "Submitted for Manual Review" : receipt.status )
                        .foregroundColor(receiptVM.getColor(for: receipt.status))
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
		ReceiptListItem(receipt: Receipt(id: "Receipt 56g",
										 receiptId: "3453463",
										 name: "Receipt",
										 status: "Draft",
										 storeName: "Ratna cafe",
										 purchaseDate: "08/09/2023",
										 totalAmount: "$4500",
										 totalPoints: 50,
										 createdDate: "03/05/2022",
										 imageUrl: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg",
										 processedAwsReceipt: "{\n  \"totalAmount\" : \"$154.06\",\n  \"storeName\" : \"East Repair Inc.\"n}"))
    }
}
