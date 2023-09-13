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
	@StateObject var viewModel = ReceiptListViewModel()
	@EnvironmentObject var cameraViewModel: CameraViewModel
	@StateObject var receiptViewModel = ReceiptViewModel()
	@State var searchText = ""
	@State var showCapturedImage: Bool = false
	@State var capturedImage: UIImage?
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				ReceiptSearchBar(fieldValue: $viewModel.searchText)
					.padding(.leading)
				Text(StringConstants.Receipts.uploadReceiptButton)
					.font(.boldButtonText)
					.longFlexibleButtonStyle()
					.frame(width: 140)
					.accessibilityIdentifier(AppAccessibilty.receipts.newButton)
					.onTapGesture {
						cameraViewModel.showCamera = true
					}
			}
			if !viewModel.isLoading && (viewModel.receipts.isEmpty || viewModel.filteredReceipts.isEmpty) {
				ScrollView {
					EmptyStateView(title: "No Receipts")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			} else {
				ZStack {
					ReceiptList()
						.environmentObject(viewModel)
						.refreshable {
							await Task {
								await getReceipts(forced: true)
							}.value
						}
					if viewModel.isLoading {
						ProgressView()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color.theme.background)
					}
				}
			}
		}
		.loytaltyNavigationTitle(StringConstants.Receipts.receiptsListTitle)
		.loyaltyNavBarSearchButtonHidden(true)
		.environmentObject(routerPath)
		.environmentObject(cameraViewModel)
		.environmentObject(receiptViewModel)
		.background(Color.theme.background)
		.task {
			await getReceipts()
		}
		.background(Color.theme.background)
		.fullScreenCover(isPresented: $cameraViewModel.showCamera) {
			ZStack {
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
				.environmentObject(viewModel)
			}
		}
	}
	
	func getReceipts(forced: Bool = false) async {
		do {
			try await viewModel.getReceipts(membershipNumber: rootVM.member?.membershipNumber ?? "", forced: forced)
		} catch {
			Logger.error(error.localizedDescription)
		}
	}
}

struct ReceiptsView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptsView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.routerPath)
	}
}
