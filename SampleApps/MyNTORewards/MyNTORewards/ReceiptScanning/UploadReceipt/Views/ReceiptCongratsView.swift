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
	@EnvironmentObject var receiptlistViewModel: ReceiptListViewModel
	@EnvironmentObject var rootViewModel: AppRootViewModel
	var points: Double
	var body: some View {
		ZStack {
			VStack {
				Image("img-congrats")
					.resizable()
					.scaledToFit()
				Spacer()
			}
			VStack {
				Spacer()
				Image("img-gift")
					.padding(.top, 60)
				Text(StringConstants.Receipts.receiptUploadedText)
					.font(.congratsTitle)
					.padding(.top, 30)
					.padding(.bottom, 2)
					.accessibilityIdentifier(AppAccessibilty.receipts.receiptSubmittedCongrats)
				
				Text("We’ve credited \(points.truncate(to: 2)) points for the uploaded receipt")
					.font(.congratsText)
					.lineSpacing(5)
					.multilineTextAlignment(.center)
					.padding([.leading, .trailing], 40)
				Spacer()
				Text("Done")
					.onTapGesture {
						routerPath.dismissSheets()
						Task {
							do {
								try await receiptlistViewModel.getReceipts(membershipNumber: rootViewModel.member?.membershipNumber ?? "", forced: true)
							} catch { }
						}
					}
					.longFlexibleButtonStyle()
				Button(StringConstants.Receipts.uploadAnotherReceiptButton) {
					routerPath.dismissSheets()
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
						cameraModel.showCamera = true
					}
				}
				.padding(.bottom, 20)
				.foregroundColor(.black)
				.accessibilityIdentifier(AppAccessibilty.receipts.scanAnotherReceipt)
			}
		}
	}
}

#if !TESTING
struct ReceiptCongratsView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptCongratsView(points: 50)
	}
}
#endif
