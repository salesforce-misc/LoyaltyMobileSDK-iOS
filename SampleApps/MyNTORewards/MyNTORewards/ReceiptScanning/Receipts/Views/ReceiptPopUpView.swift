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
	@State var selectedDetent: PresentationDetent = .receiptDetailPopUp
	
	@State var detents: Set<PresentationDetent> = [.receiptDetailPopUp, .manualReview]
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
			if showManualReviewRequest {
				ManualReviewInputView(showManualReviewRequest: $showManualReviewRequest, selectedDetent: $selectedDetent,
									  receiptNumber: "42588",
									  receiptDate: "13/07/2023",
									  amount: "INR 32392",
									  points: "432 Points")
			} else {
				ReceiptDetailView(receiptNumber: "42588",
								  receiptDate: "13/07/2023",
								  amount: "INR 32392",
								  points: "432 Points",
								  showManualReviewRequest: $showManualReviewRequest, selectedDetent: $selectedDetent)
			}
		}
		.presentationDetents(detents, selection: $selectedDetent)
		.onChange(of: selectedDetent) { newValue in
			if newValue == .receiptDetailPopUp {
				updateDetentsWithDelay()
			} else {
				detents = [.receiptDetailPopUp, .manualReview]
			}
		}
	}
	
	func updateDetentsWithDelay() {
		Task {
			//(1 second = 1_000_000_000 nanoseconds)
			try? await Task.sleep(nanoseconds: 100_000_000)
			guard selectedDetent == .receiptDetailPopUp else { return }
			detents = [.receiptDetailPopUp]
		}
	}
}

struct ReceiptPopUpView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptPopUpView()
    }
}
