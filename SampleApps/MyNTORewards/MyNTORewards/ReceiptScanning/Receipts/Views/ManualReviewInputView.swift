//
//  ManualReviewInputView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI

struct ManualReviewInputView: View {
	@EnvironmentObject var routerPath: RouterPath
	@State private var comment: String = ""
	@Binding var showManualReviewRequest: Bool
	@Binding var selectedDetent: PresentationDetent
	let receiptNumber: String
	let receiptDate: String
	let amount: String
	let points: String

    var body: some View {
		VStack {
			VStack(spacing: 20) {
				HStack {
					Text(StringConstants.Receipts.manualReviewTitle)
						.font(.manualReviewTitleLabel)
						.padding(.leading, 25)
						.padding(.top, 2)
					Spacer()
				}
				HStack {
					VStack(alignment: .leading, spacing: 8) {
						Text("Receipt \(receiptNumber)")
							.font(.transactionText)
							.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
						Text("Date \(receiptDate)")
							.font(.transactionDate)
							.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
					}
					Spacer()
					VStack(alignment: .trailing, spacing: 8) {
						Text("\(amount)")
							.font(.transactionText)
							.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
						Text("\(points) Points")
							.font(.transactionDate)
							.accessibilityIdentifier(AppAccessibilty.receipts.receiptPointsText)
					}
					.padding(.trailing, 15)
				}
				.padding(.horizontal, 25)
				.padding(.bottom, 8)
			}
			CommentsInputView(comment: $comment)
				.padding(8)
			Text(StringConstants.Receipts.submitForManualReviewButton)
				.onTapGesture {
					routerPath.presentedSheet = nil
				}
				.longFlexibleButtonStyle()
			Button {
				showManualReviewRequest = false
				selectedDetent = .receiptDetailPopUp
			} label: {
				Text(StringConstants.Receipts.cancelButton)
					.foregroundColor(.black)
			}
			.padding(.bottom, 20)
			.accessibilityIdentifier(AppAccessibilty.receipts.backButton)
		}
		.background(Color.theme.background)
    }
}

struct CommentsInputView: View {
	@Binding var comment: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			Text(StringConstants.Receipts.commentsHeader)
				.padding(.leading)
				.font(.manualReviewCommentLabel)
				.foregroundColor(Color.theme.manualReviewCommentLabelColor)
			TextField(StringConstants.Receipts.enterCommentsPlaceholder, text: $comment, axis: .vertical)
				.lineLimit(8, reservesSpace: true)
				.textFieldStyle(GrayedTextFieldStyle())
		}
	}
}

struct ManualReviewInputView_Previews: PreviewProvider {
    static var previews: some View {
		ManualReviewInputView(showManualReviewRequest: .constant(true),
							  selectedDetent: .constant(.large),
							  receiptNumber: "42588",
							  receiptDate: "13/07/2023",
							  amount: "INR 32392",
							  points: "432 Points")
    }
}
