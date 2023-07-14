//
//  ReceiptPopUpView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 13/07/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct ReceiptPopUpView: View {
	let receiptNumber: String
	let receiptDate: String
	@Environment(\.dismiss) private var dismiss
    var body: some View {
		VStack {
			HStack {
				VStack(spacing: 8) {
					HStack {
						Text("\(receiptNumber)")
							.font(.transactionText)
						Spacer()
						Button {
							dismiss()
						} label: {
							Image(systemName: "xmark")
								.foregroundColor(.gray)
						}
					}
					HStack {
						Text("\(receiptDate)")
							.font(.transactionDate)
						Spacer()
					}
				}
			}
			.padding(.top, 30)
			.padding(.horizontal)
			.padding(.bottom, 8)
//			LoyaltyAsyncImage(url: "") { image in
//				image
//					.resizable()
//					.scaledToFill()
//					.frame(width: 300, height: 200)
//			} placeholder: {
//				ProgressView()
//			}
			Image("scanned_receipt")
				.resizable()
				.frame(width: 330, height: 323)
			Button {
				// Download
			} label: {
				Text("Download")
					.underline()
					.foregroundColor(.black)
			}
			.padding(.top, 8)

		}
    }
}

struct ReceiptPopUpView_Previews: PreviewProvider {
    static var previews: some View {
		ReceiptPopUpView(receiptNumber: "42588", receiptDate: "13/07/2023")
    }
}
