//
//  ReceiptPopUpView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

extension PresentationDetent {
	static var receiptDetailPopUp: PresentationDetent = .height(800)
	static var manualReview: PresentationDetent = .height(524)
}

struct ReceiptPopUpView: View {
	@EnvironmentObject var receiptViewModel: ReceiptViewModel
	@EnvironmentObject var routerPath: RouterPath
	@State var showManualReviewRequest: Bool = false
	var body: some View {
		VStack(spacing: 20) {
			HStack {
				Spacer()
				Button {
					routerPath.presentedSheet = nil
				} label: {
					Image(systemName: "xmark")
						.foregroundColor(.gray)
				}
				.padding(.trailing, 10)
				.accessibility(identifier: AppAccessibilty.receipts.closeButton)
			}
			.padding(.top, 12)
			ManualReviewInputView(receiptNumber: "42588",
								  receiptDate: "13/07/2023",
								  amount: "INR 32392",
								  points: "432 Points")
		}
		.presentationDetents([.manualReview])
	}
}

struct ReceiptPopUpView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptPopUpView()
	}
}
