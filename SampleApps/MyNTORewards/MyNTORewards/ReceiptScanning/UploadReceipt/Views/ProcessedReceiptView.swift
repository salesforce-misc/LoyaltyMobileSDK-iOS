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
    @State private var isLoading = false
    @State private var isError = false
    
    var body: some View {
        if let processedReceipt = viewModel.processedReceipt, !isError {
            ZStack {
                VStack {
                    header(receipt: processedReceipt)
                    if viewModel.receiptScanSatus == .receiptNotReadable || viewModel.receiptScanSatus == .receiptPartiallyReadable {
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
        } else { errorView }
    }
    
    private func header(receipt: ProcessedReceipt) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Receipt \(receipt.receiptNumber)")
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
    
    private func tryAgainButton(receipt: ProcessedReceipt) -> some View {
        Button(StringConstants.Receipts.tryAgainButton) {
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
        .foregroundColor(.black)
        .padding([.horizontal], 16)
        .accessibilityIdentifier(AppAccessibilty.Receipts.tryAgainButtonProcessedReceipt)
    }
    
    private func requestManualReviewButton(receipt: ProcessedReceipt) -> some View {
        Button(StringConstants.Receipts.requestForManualReviewButton) {
            
        }
        .foregroundColor(.black)
    }
    
    private func cancelButton() -> some View {
        Button(StringConstants.Receipts.cancelButton) {
            
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
                    tryAgainButton(receipt: receipt)
                    requestManualReviewButton(receipt: receipt)
                }
            case .receiptNotReadable:
                VStack(alignment: .center, spacing: 20) {
                    tryAgainButton(receipt: receipt)
                    cancelButton()
                }
            case .receiptPartiallyReadable:
                VStack(alignment: .center, spacing: 20) {
                    tryAgainButton(receipt: receipt)
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
