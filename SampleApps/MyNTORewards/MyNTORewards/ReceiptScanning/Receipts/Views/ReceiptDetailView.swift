//
//  ReceiptDetailsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 24/08/23.
//

import SwiftUI

struct ReceiptDetailView: View {
	@EnvironmentObject var routerPath: RouterPath
    @EnvironmentObject var localeManager: LocaleManager
    @StateObject var processedReceiptViewModel = ProcessedReceiptViewModel()
	@StateObject var imageVM = ImageViewModel()
	@State private var tabIndex = 0
	@State private var showManualReviewRequest = false
	@State private var showManualReviewSubmittedAlert = false
	@State private var showPhotoDownloadedAlert = false
	@State private var isTableLoading = true
	var tabbarItems = ["Receipt Items", "Receipt Image"]
	let receipt: Receipt
    var body: some View {
        VStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Receipt \(receipt.receiptId)")
                            .font(.transactionText)
                            .accessibilityIdentifier(AppAccessibilty.Receipts.receiptNumberText)
                        Spacer()
                        if receipt.status == "Processed" {
                            Text("\(receipt.totalPoints?.truncate(to: 2) ?? "0") Points")
                                .font(.transactionDate)
                                .fontWeight(.medium)
                                .accessibilityIdentifier(AppAccessibilty.Receipts.receiptPointsText)
                                .foregroundColor(Color("PointsColor"))
                        }
                    }
                    HStack {
                        Text("Date: \(receipt.purchaseDate?.toString(withFormat: localeManager.currentDateFormat) ?? " - ")")
                            .font(.transactionDate)
                            .accessibilityIdentifier(AppAccessibilty.Receipts.receiptDateText)
                        Spacer()
                        if receipt.status != "Processed" {
                            Text(receipt.status == "Manual Review" ? "In Manual Review": receipt.status)
								.foregroundColor(Color.theme.receiptStatusPending)
								.font(.transactionDate)
						}
                    }
                }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            TopTabBar(barItems: tabbarItems, tabIndex: $tabIndex)
            ZStack {
                Color.theme.background
                TabView(selection: $tabIndex) {
                    if processedReceiptViewModel.processedAwsResponse != nil {
                        ProcessedReceiptList(eligibleItems: processedReceiptViewModel.eligibleItems,
                                             ineligibleItems: processedReceiptViewModel.inEligibleItems)
                        .backgroundStyle(Color.theme.background)
                        .padding(20)
                        .tag(0)
                    } else {
                        if isTableLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.theme.background)
                        } else {
                            Text("No Data")
                        }
                    }
                    ZoomableScrollView {
						LoyaltyAsyncImage(url: receipt.imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .padding(20)
                    .tag(1)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            if tabIndex == 0 {
                if "Manual Review" != receipt.status {
                    Button {
                        showManualReviewRequest = true
                    } label: {
                        Text("Request a Manual Review")
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20)
                    .opacity(1)
                    .padding(.bottom, 20)
                }
            } else {
                Button {
                    Task {
                        if let urlString = receipt.imageUrl {
                            await imageVM.getImage(url: urlString)
                            if let image = imageVM.images[urlString.MD5] {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                showPhotoDownloadedAlert = true
                            }
                        }
                    }
                } label: {
                    Text("Download Original Receipt")
                        .foregroundColor(receipt.imageUrl == nil ? .gray : .black)
                }
                .disabled(receipt.imageUrl == nil)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
		}
		.onAppear {
			Task {
				do {
					isTableLoading = true
					try await processedReceiptViewModel.getProcessedReceiptItems(from: receipt)
					isTableLoading = false
				} catch {
					isTableLoading = false
					// TODO: show error on processed receipts tab
				}
			}
		}
		.loytaltyNavigationTitle("Receipt Details")
		.loyaltyNavBarSearchButtonHidden(true)
		.sheet(isPresented: $showManualReviewRequest) {
			ManualReviewInputView(showManualReviewRequest: $showManualReviewRequest, showManualReviewSubmittedAlert: $showManualReviewSubmittedAlert, receipt: receipt)
				.interactiveDismissDisabled()
				.presentationDetents(Set([ .height(524)]))
		}
		.alert(StringConstants.Receipts.receiptSavedToPhotos, isPresented: $showPhotoDownloadedAlert, actions: {
			Text("OK")
		})
		.alert(getRequestSubmittedAlertMessage(), isPresented: $showManualReviewSubmittedAlert, actions: {
			Text("OK")
		})
		.environmentObject(processedReceiptViewModel)
    }
	
	private func getRequestSubmittedAlertMessage() -> String {
		return "Receipt \(receipt.receiptId) was submitted for manual review."
	}
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptDetailView(receipt: Receipt(id: "Receipt 56g",
										   receiptId: "3453463",
										   name: "Receipt",
										   status: "Draft",
										   storeName: "Ratna cafe",
										   purchaseDate: Date(),
										   totalAmount: "$4500",
										   totalPoints: 50,
										   createdDate: "03/05/2022",
										   imageUrl: "https://hpr.com/wp-content/uploads/2021/08/FI_receipt_restaurant.jpg",
										   processedAwsReceipt: "{\n  \"totalAmount\" : \"$154.06\",\n  \"storeName\" : \"East Repair Inc.\"n}"))
    }
}
