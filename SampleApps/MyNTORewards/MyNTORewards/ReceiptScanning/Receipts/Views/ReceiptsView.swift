//
//  ReceiptsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptsView: View {
	@EnvironmentObject var rootVM: AppRootViewModel
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
	@EnvironmentObject var cameraVM: CameraViewModel
	@StateObject var receiptViewModel = ReceiptViewModel()
	@State var searchText = ""
	@State var isLoading = false
    @State var showCapturedImage: Bool = false
    @State var showErrowView: Bool = false
    @State var capturedImage: UIImage?
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Text("Receipts")
					.font(.congratsTitle)
					.padding(.leading, 15)
					.accessibilityIdentifier(AppAccessibilty.Receipts.receiptsViewTitle)
				Spacer()
			}
			.frame(height: 44)
			.frame(maxWidth: .infinity)
			.background(.white)
			HStack(spacing: 0) {
				ReceiptSearchBar(fieldValue: $receiptListViewModel.searchText)
					.padding(.leading)
				Text(StringConstants.Receipts.uploadReceiptButton)
					.font(.boldButtonText)
					.longFlexibleButtonStyle()
					.frame(width: 140)
					.accessibilityIdentifier(AppAccessibilty.Receipts.newButton)
					.onTapGesture {
						cameraVM.showCamera = true
					}
			}
			if !isLoading && (receiptListViewModel.receipts.isEmpty || receiptListViewModel.filteredReceipts.isEmpty) {
				ScrollView {
					EmptyStateView(title: "No Receipts")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			} else {
				ZStack {
					ReceiptList()
						.animation(.default, value: receiptListViewModel.filteredReceipts)
						.environmentObject(receiptListViewModel)
						.refreshable {
							await Task {
								await getReceipts(forced: true)
							}.value
						}
					if isLoading {
						ProgressView()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color.theme.background)
					}
				}
			}
		}
		.navigationBarBackButtonHidden()
		.environmentObject(routerPath)
		.environmentObject(cameraVM)
		.environmentObject(receiptViewModel)
		.background(Color.theme.background)
		.task {
			await getReceipts()
		}
		.background(Color.theme.background)
        .fullScreenCover(isPresented: $cameraVM.showCamera) {
            ZStack {
                CameraView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
                    .zIndex(showCapturedImage ? 0 : 1)
                if showCapturedImage {
                    CapturedImageView(showCapturedImage: $showCapturedImage, capturedImage: $capturedImage)
                        .transition(.move(edge: .trailing))
                        .zIndex(showCapturedImage ? 1 : 0)
                }
            }
            .animation(.default, value: showCapturedImage)
            .environmentObject(routerPath)
            .environmentObject(receiptListViewModel)
        }
        .fullScreenCover(isPresented: $cameraVM.showErrorView) {
            Spacer()
            ProcessingErrorView(message: StringConstants.Receipts.fileSizeErrorMessage)
            Spacer()
            Button {
                cameraVM.showErrorView = false
            } label: {
                Text(StringConstants.Receipts.backButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .longFlexibleButtonStyle()
            .accessibilityIdentifier(AppAccessibilty.Receipts.errorBackButton)
        }
	}
	
	func getReceipts(forced: Bool = false) async {
		do {
			isLoading = true
			try await receiptListViewModel.getReceipts(membershipNumber: rootVM.member?.membershipNumber ?? "", forced: forced)
			isLoading = false
		} catch {
			isLoading = false
			Logger.error(error.localizedDescription)
		}
	}
}

struct ReceiptsView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.routerPath)
			.environmentObject(dev.receiptListVM)
			.environmentObject(dev.camVM)
	}
}
