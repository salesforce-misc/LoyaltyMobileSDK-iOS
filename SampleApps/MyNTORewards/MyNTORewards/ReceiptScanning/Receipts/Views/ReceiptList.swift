//
//  ReceiptList.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptList: View {
	@EnvironmentObject var routerPath: RouterPath
	var receipts: [Receipt]
    var body: some View {
		List {
			ForEach(receipts) { receipt in
				ReceiptListItem(receiptNumber: receipt.receiptId,
								receiptDate: receipt.purchaseDate,
								amount: receipt.totalAmount,
								points: receipt.totalPoints,
								currency: "USD",
								status: receipt.status)
					.padding(-3)
					.onTapGesture {
						routerPath.presentedSheet = .storedReceipt
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList(receipts: [])
    }
}
