//
//  ReceiptCongratsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 26/07/23.
//

import SwiftUI

struct ReceiptCongratsView: View {
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var cameraModel: CameraViewModel
	@EnvironmentObject var receiptListViewModel: ReceiptListViewModel
	@EnvironmentObject var rootViewModel: AppRootViewModel
	var points: Double?
	var body: some View {
		ZStack {
			VStack {
				Image("img-congrats")
					.resizable()
					.scaledToFit()
				Spacer()
			}
            ConfettiView()
			VStack {
				Spacer()
				Image("img-gift")
					.padding(.top, 60)
				Text(StringConstants.Receipts.receiptUploadedText)
					.font(.congratsTitle)
					.padding(.top, 30)
					.padding(.bottom, 2)
					.accessibilityIdentifier(AppAccessibilty.Receipts.receiptSubmittedCongrats)
				Text(getMessage(for: points))
					.font(.congratsText)
					.lineSpacing(5)
					.multilineTextAlignment(.center)
					.padding([.leading, .trailing], 40)
				Spacer()
                Button {
                    routerPath.dismissSheets()
                    Task {
                        try await reloadReceipts()
                    }
                } label: {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .longFlexibleButtonStyle()
				Button(StringConstants.Receipts.uploadAnotherReceiptButton) {
					routerPath.dismissSheets()
					Task {
						try await reloadReceipts()
					}
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						cameraModel.showCamera = true
					}
				}
				.padding(.bottom, 20)
				.foregroundColor(.black)
				.accessibilityIdentifier(AppAccessibilty.Receipts.scanAnotherReceipt)
			}
		}
	}
	
	private func getMessage(for points: Double?) -> String {
		if let points = points {
			return "We’ve credited \(points.truncate(to: 2)) points for the uploaded receipt."
		} else {
			return "Calculating loyalty points for the eligible items can take a while. Check back later."
		}
	}
	
	private func reloadReceipts() async throws {
		try await receiptListViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "",
												   forced: true)
	}
}

#if !TESTING
struct ReceiptCongratsView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptCongratsView(points: 50)
	}
}
#endif
