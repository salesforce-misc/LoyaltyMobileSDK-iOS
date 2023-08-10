//
//  ReceiptCongratsView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 26/07/23.
//

import SwiftUI

struct ReceiptCongratsView: View {
	@EnvironmentObject var routerPath: RouterPath
	@EnvironmentObject var cameraModel: CameraModel
	var points: Double
	var body: some View {
		VStack {
			Image("img-congrats")
				.resizable()
				.scaledToFit()
			Image("img-gift")
			Text("Your receipt is uploaded!")
				.font(.congratsTitle)
				.padding(.top, 30)
				.padding()
				.accessibilityIdentifier(AppAccessibilty.receipts.receiptSubmittedCongrats)
			
			Text("We’ve credited \(points.truncate(to: 2)) points for the uploaded receipt")
				.font(.congratsText)
				.lineSpacing(5)
				.multilineTextAlignment(.center)
				.padding([.leading, .trailing], 40)
			Spacer()
			Text("Done")
				.onTapGesture {
					routerPath.presentedSheet = nil
					routerPath.presentedFullSheet = nil
				}
				.longFlexibleButtonStyle()
			Button("Upload Another Receipt") {
				// button action
				routerPath.presentedSheet = nil
				routerPath.presentedFullSheet = nil
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					cameraModel.showCamera = true
				}
			}
			.foregroundColor(.black)
			.accessibilityIdentifier(AppAccessibilty.receipts.scanAnotherReceipt)
		}
		.ignoresSafeArea(edges: .top)
	}
}

#if !TESTING
struct ReceiptCongratsView_Previews: PreviewProvider {
	static var previews: some View {
		ReceiptCongratsView(points: 250)
	}
}
#endif
