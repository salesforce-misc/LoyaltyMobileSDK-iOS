//
//  ProcessedReceiptView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 17/07/23.
//

import SwiftUI

struct ProcessedReceiptView: View {
    @EnvironmentObject var localeManager: LocaleManager
    @EnvironmentObject var viewModel: ProcessedReceiptViewModel
    @EnvironmentObject var cameraModel: CameraViewModel
    @EnvironmentObject var receiptlistViewModel: ReceiptListViewModel
    @EnvironmentObject var rootViewModel: AppRootViewModel
    @EnvironmentObject var routerPath: RouterPath
	@Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var isError = false
	@State private var showManualReview = false
	@State private var showManualReviewSubmittedAlert = false
    
    var body: some View {
        if let processedReceipt = viewModel.processedReceipt, !isError {
            if viewModel.receiptScanSatus == .receiptNotReadable {
                VStack {
                    ReceiptScanErrorView(scanStatus: viewModel.receiptScanSatus)
                            .padding()
                    Spacer()
                    bottomButtonsView(receipt: processedReceipt)
                }.background(Color.white)
                
            } else {
                ZStack {
                    VStack {
						HStack {
                            Button {
                                updateReceiptStatusForTryAgainAction(receipt: processedReceipt)
								dismiss()
								Task {
									try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "",
																			   forced: true)
								}
								DispatchQueue.main.async {
									cameraModel.showCamera = true
								}
							} label: {
								Image("ic-backarrow")
							}
							Spacer()
						}
						.padding([.bottom, .leading], 16)
						.padding(.top, 48)
						.background(.white)
                        header(receipt: processedReceipt)
                        if  viewModel.receiptScanSatus == .receiptPartiallyReadable {
                            ReceiptScanErrorView(scanStatus: viewModel.receiptScanSatus)
                                .padding()
                            
                        } else {
                            ProcessedReceiptList(eligibleItems: viewModel.eligibleItems,
                                                 ineligibleItems: viewModel.inEligibleItems)
                            .padding()
                        }
                        Spacer()
                        bottomButtonsView(receipt: processedReceipt)
                    }
                    .padding(.vertical, 20)
                    .background(Color.theme.background)
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.theme.progressBarBackground)
                            .opacity(0.7)
                    }
                }
				.edgesIgnoringSafeArea(.top)
				.sheet(isPresented: $showManualReview, content: {
					ManualReviewInputView(showManualReviewRequest: $showManualReview,
										  showManualReviewSubmittedAlert: $showManualReviewSubmittedAlert,
										  receiptId: processedReceipt.receiptSFDCId,
										  receiptNumber: processedReceipt.receiptNumber,
										  purchaseDate: processedReceipt.receiptDate,
										  totalAmount: processedReceipt.totalAmount,
										  totalPoints: nil)
					.interactiveDismissDisabled()
					.presentationDetents(Set([ .height(524)]))
				})
				.alert("Receipt was submitted for manual review.", isPresented: $showManualReviewSubmittedAlert, actions: {
					Text("OK")
				})
				.onChange(of: showManualReview) { newValue in
					if !newValue {
						routerPath.dismissSheets()
					}
				}
            }
        } else { errorView }
    }
    
    private func header(receipt: ProcessedReceipt) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Receipt \(receipt.receiptNumber ?? "")")
                .font(.offerTitle)
                .accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberLabel)
            HStack {
                Text("Store: \(receipt.storeName)")
                    .accessibilityIdentifier(AppAccessibilty.Receipts.storeLabel)
                Spacer()
                Text("Date: \(receipt.receiptDate?.toString(withFormat: localeManager.currentDateFormat) ?? "-")")
                    .accessibilityIdentifier(AppAccessibilty.Receipts.receiptDate)
            }
            .font(.offerText)
        }
        .padding(.horizontal)
		.padding(.top, 8)
    }
    
    private func submitButton(receipt: ProcessedReceipt) -> some View {
        Button {
            Task {
                do {
                    isLoading = true
                    let success = try await viewModel.updateStatus(receiptId: receipt.receiptSFDCId, status: .inProgress)
                    if success {
                        let receipt = await viewModel.wait(until: .processed,
                                                           forReceiptId: receipt.receiptSFDCId ?? "",
                                                           membershipNumber: rootViewModel.member?.membershipNumber ?? "",
                                                           delay: 2,
                                                           retryCount: 5)
                        viewModel.receiptState = .submitted(receipt?.totalPoints)
                    } else { isError = true }
                    isLoading = false
                } catch {
                    isLoading = false
                    isError = true
                }
            }
        } label: {
            Text(StringConstants.Receipts.submitButton)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier(AppAccessibilty.Receipts.submitReceiptButton)
        }
        .buttonStyle(.borderedProminent)
        .longFlexibleButtonStyle()
    }
    
    func updateReceiptStatusForTryAgainAction(receipt: ProcessedReceipt) {
        Task {
            routerPath.presentedSheet = nil
            do {
                isLoading = true
                let success = try await viewModel.updateStatus(receiptId: receipt.receiptSFDCId, status: .cancelled)
                if success {
                    try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "",
                                                               forced: true)
                }
                isLoading = false
            } catch {
                isLoading = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cameraModel.showCamera = true
        }
    }
    
    private func tryAgainButton(receipt: ProcessedReceipt) -> some View {
        Button(StringConstants.Receipts.tryAgainButton) {
            updateReceiptStatusForTryAgainAction(receipt: receipt)
        }
        .foregroundColor(.black)
        .padding([.horizontal], 16)
        .accessibilityIdentifier(AppAccessibilty.Receipts.tryAgainButtonProcessedReceipt)
    }
    
    private func tryAgainButtonWithCornerRadious(receipt: ProcessedReceipt) -> some View {
        Button(StringConstants.Receipts.tryAgainButton) {
            updateReceiptStatusForTryAgainAction(receipt: receipt)
        }
        .foregroundColor(.black)
        .buttonStyle(DarkFlexibleButton())
        .padding([.horizontal], 16)
        .accessibilityIdentifier(AppAccessibilty.Receipts.tryAgainButtonProcessedReceipt)
    }
    
    private func requestManualReviewButton(receipt: ProcessedReceipt) -> some View {
        Button(StringConstants.Receipts.submitForManualReviewButton) {
			showManualReview = true
        }
        .foregroundColor(.black)
    }
    
    private func cancelButton() -> some View {
        Button(StringConstants.Receipts.backButton) {
            routerPath.presentedSheet = nil
        }
        .foregroundColor(.black)
    }
    
    private func bottomButtonsView(receipt: ProcessedReceipt) -> some View {
        Group {
            switch viewModel.receiptScanSatus {
            case .allEligibleItems:
                VStack(alignment: .center, spacing: 20) {
                    submitButton(receipt: receipt)
                    tryAgainButton(receipt: receipt)
                }
            case .bothEligibleAndInEligibleItems:
                VStack(alignment: .center, spacing: 20) {
                    submitButton(receipt: receipt)
                    tryAgainButton(receipt: receipt)
                    requestManualReviewButton(receipt: receipt)
                }
            case .noEligibleItems:
                VStack(alignment: .center, spacing: 20) {
                    tryAgainButtonWithCornerRadious(receipt: receipt)
                    requestManualReviewButton(receipt: receipt)
                }
            case .receiptNotReadable:
                VStack(alignment: .center, spacing: 20) {
                    tryAgainButtonWithCornerRadious(receipt: receipt)
                    cancelButton()
                }
            case .receiptPartiallyReadable:
                VStack(alignment: .center, spacing: 20) {
                    tryAgainButtonWithCornerRadious(receipt: receipt)
                    requestManualReviewButton(receipt: receipt)
                }
            }
        }
    }
    
    private var errorView: some View {
        VStack {
            Spacer()
            if let error = viewModel.processedError {
                ProcessingErrorView(message: "\(error)")
            } else {
                ProcessingErrorView(message: StringConstants.Receipts.processingErrorMessage)
            }
            
            Spacer()
            Spacer()
            Button {
                // button action
                routerPath.presentedSheet = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cameraModel.showCamera = true
                    viewModel.processedError = nil
                }
            } label: {
                Text(StringConstants.Receipts.tryAgainButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .longFlexibleButtonStyle()
            Button {
                routerPath.presentedSheet = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.processedError = nil
                }
            } label: {
                Text(StringConstants.Receipts.backButton)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 20)
            .accessibilityIdentifier(AppAccessibilty.Receipts.backButton)
        }
    }
}

struct ProcessedReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessedReceiptView()
            .environmentObject(dev.processedReceiptVM)
            .environmentObject(dev.camVM)
            .environmentObject(dev.receiptVM)
    }
}
