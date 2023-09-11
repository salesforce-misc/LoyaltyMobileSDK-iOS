//
//  ManualReviewInputView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI

struct ManualReviewInputView: View {
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@Binding var showManualReviewRequest: Bool
	@Environment(\.dismiss) var dismiss
	@State private var comment: String = ""
	@State private var isLoading = false
	let receipt: Receipt
	
    var body: some View {
		ZStack {
			VStack {
				HStack {
					Spacer()
					Button {
						showManualReviewRequest = false
					} label: {
						Image(systemName: "xmark")
							.foregroundColor(.gray)
					}
					.padding(.trailing, 10)
					.accessibility(identifier: AppAccessibilty.receipts.closeButton)
				}
				.padding(.top, 12)
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
							Text("Receipt \(receipt.receiptId ?? "-")")
								.font(.transactionText)
								.accessibilityIdentifier(AppAccessibilty.receipts.receiptNumberText)
							Text("Date \(receipt.purchaseDate?.toDateString() ?? "-")")
								.font(.transactionDate)
								.accessibilityIdentifier(AppAccessibilty.receipts.receiptDateText)
						}
						Spacer()
						VStack(alignment: .trailing, spacing: 8) {
							Text("\(receipt.totalAmount ?? "0")")
								.font(.transactionText)
								.accessibilityIdentifier(AppAccessibilty.receipts.receiptAmountText)
							Text("\(receipt.totalPoints ?? "0") Points")
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
						Task {
							do {
								let success = try await processedReceiptViewModel.submitForManualReview(receiptId: receipt.id ?? "-", comments: "test")
								if success {
									receipt.status = "Manual Review"
									dismiss()
								}
							} catch {
								// MARK: handle error
							}
						}
					}
					.longFlexibleButtonStyle(disabled: comment.isEmpty)
				Button {
					dismiss()
				} label: {
					Text(StringConstants.Receipts.cancelButton)
						.foregroundColor(.black)
				}
				.padding(.bottom, 20)
				.accessibilityIdentifier(AppAccessibilty.receipts.backButton)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.theme.background)
			
			if processedReceiptViewModel.isLoading {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.theme.background)
					.opacity(0.7)
			}
		}
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
		ManualReviewInputView(showManualReviewRequest: .constant(true), receipt: Receipt()
		)
    }
}
