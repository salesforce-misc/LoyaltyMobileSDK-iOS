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
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
//	@StateObject var receiptViewModel = ReceiptViewModel()
//	@State private var showManualReviewRequest = false
//	@State var isShowingModel: Bool = false
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
//						isShowingModel = true
					}
			}
			.listRowSeparator(.hidden)
		}
		.listStyle(.plain)
//		.sheet(isPresented: $isShowingModel) {
//			ReceiptPopUpView(showManualReviewRequest: $showManualReviewRequest, isPresented: $isShowingModel)
//				.presentationDetents(showManualReviewRequest ? [.height(524)] : [.height(700)]).animation(.easeIn, value: showManualReviewRequest)
//		}
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptList(receipts: [])
    }
}
