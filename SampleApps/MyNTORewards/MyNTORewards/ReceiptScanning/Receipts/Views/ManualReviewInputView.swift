//
//  ManualReviewInputView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/08/23.
//

import SwiftUI

struct ManualReviewInputView: View {
	@EnvironmentObject var processedReceiptViewModel: ProcessedReceiptViewModel
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
	@EnvironmentObject var rootVM: AppRootViewModel
    @EnvironmentObject var localeManager: LocaleManager
	@Binding var showManualReviewRequest: Bool
	@Binding var showManualReviewSubmittedAlert: Bool
	@Environment(\.dismiss) var dismiss
	@State private var comment: String = ""
	@State private var isLoading = false
	let receiptId: String?
	let receiptNumber: String?
	let purchaseDate: Date?
	let totalAmount: String?
	let totalPoints: Double?
	
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
					.accessibility(identifier: AppAccessibilty.Receipts.closeButton)
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
							Text("Receipt \(receiptNumber ?? "--")")
								.font(.transactionText)
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberText)
                            Text("Date \(purchaseDate?.toString(withFormat: localeManager.currentDateFormat) ?? "-")")
								.font(.transactionDate)
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptDateText)
						}
						Spacer()
						Spacer()
						VStack(alignment: .trailing, spacing: 8) {
							Text("\(totalAmount ?? "0")")
								.font(.transactionText)
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptAmountText)
							Text("\(totalPoints?.truncate(to: 2) ?? "0") Points")
								.font(.transactionDate)
								.accessibilityIdentifier(AppAccessibilty.Receipts.receiptPointsText)
						}
						.padding(.trailing, 15)
					}
					.padding(.horizontal, 25)
					.padding(.bottom, 8)
				}
				CommentsInputView(comment: $comment)
					.padding(8)
                Button {
                    Task {
                        do {
                            isLoading = true
                            let success = try await processedReceiptViewModel.updateStatus(receiptId: receiptId, status: .manualReview, comments: comment)
                            if success {
                                dismiss()
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
									showManualReviewSubmittedAlert = true
								}
                                try await receiptListViewModel.getReceipts(membershipNumber: rootVM.member?.membershipNumber ?? "", forced: true)
                            }
                            isLoading = false
                        } catch {
                            isLoading = false
                            // MARK: handle error
                        }
                    }
                } label: {
                    Text(StringConstants.Receipts.submitForManualReviewButton)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .longFlexibleButtonStyle(disabled: comment.isEmpty)
				Button {
					dismiss()
				} label: {
					Text(StringConstants.Receipts.cancelButton)
						.foregroundColor(.black)
				}
				.padding(.bottom, 20)
				.accessibilityIdentifier(AppAccessibilty.Receipts.backButton)
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.theme.background)
			
			if isLoading {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.theme.progressBarBackground)
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
		ManualReviewInputView(showManualReviewRequest: .constant(true), 
							  showManualReviewSubmittedAlert: .constant(false), 
							  receiptId: "Receipt 56g",
							  receiptNumber: "afd3473840001", 
							  purchaseDate: Date(),
							  totalAmount: "$4500",
							  totalPoints: 50)
	}
}
