//
//  ReceiptScanningProgressView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 25/10/23.
//

import SwiftUI

struct ReceiptScanningProgressView: View {
	let numberOfSteps: Int
	let currentStep: Int
	let title: String
	let subtitle: String
	var body: some View {
		VStack {
			HStack(spacing: 0) {
				ForEach(0 ..< numberOfSteps + 1, id: \.self) { step in
					Circle()
						.strokeBorder(getStrokeColor(for: step), lineWidth: 5)
						.background(Circle().fill(getFillColor(for: step)))
						.frame(width: 35, height: 35)
					if step < numberOfSteps {
						Rectangle()
							.foregroundColor(getLineColor(step: step))
							.shimmer(.init(tint: getLineColor(step: step).opacity(0.9),
											highlight: .white,
											blur: 0,
											highlightOpacity: 2,
										   speed: 1.5
										   ),
									 enabled: step == currentStep - 1
							)
							.frame(height: 5)
					}
					
				}
			}
			.accessibilityIdentifier(AppAccessibilty.Receipts.scanningProgressView)
			.padding(48)
			VStack(spacing: 8) {
				Text(title)
					.font(.scanningReceiptTitleFont)
					.fontWeight(.heavy)
					.accessibilityIdentifier(AppAccessibilty.Receipts.scanningReceiptLabel)
				Text(subtitle)
					.font(.scanningReceiptCaptionFont)
					.accessibilityIdentifier(AppAccessibilty.Receipts.scanningReceiptSubtitle)
			}
		}
	}
	
	func getFillColor(for step: Int) -> Color {
		if step == currentStep {
			Color.white
		} else if step < currentStep {
			Color.theme.vibrantViolet
		} else {
			Color.theme.lightGray
		}
	}
	
	func getStrokeColor(for step: Int) -> Color {
		step > currentStep ? Color.white : Color.theme.vibrantViolet
	}
	
	func getLineColor(step: Int) -> Color {
		step >= currentStep ? Color.theme.lightGray : Color.theme.vibrantViolet
	}
}

#Preview {
	ReceiptScanningProgressView(numberOfSteps: 2,
								currentStep: 2,
								title: "Uploading receipt image...",
								subtitle: StringConstants.Receipts.processingScreenSubtitle)
}
