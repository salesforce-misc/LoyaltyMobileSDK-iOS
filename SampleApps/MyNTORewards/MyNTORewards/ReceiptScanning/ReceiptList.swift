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
	@State var isShowingModel: Bool = false
	var receipts: [Receipt]
    var body: some View {
		List {
			ForEach(receipts) { receipt in
				ReceiptListItem(receiptNumber: receipt.receiptNumber,
								receiptDate: receipt.receiptDate,
								amount: receipt.amount,
								points: receipt.amount,
								currency: receipt.currency)
					.padding(-3)
					.onTapGesture {
						routerPath.presentedSheet = .storedReceipt
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.sheet(isPresented: $isShowingModel) {
			HalfSheet {
				ReceiptPopUpView(receiptNumber: "43456", receiptDate: "13/07/2023")
			}
		}
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList(receipts: [])
    }
}
