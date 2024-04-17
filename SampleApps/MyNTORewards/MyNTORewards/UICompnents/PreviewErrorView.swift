//
//  PreviewErrorView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 01/04/24.
//

import SwiftUI

struct PreviewErrorView: View {
	let message: String
    var body: some View {
		VStack(spacing: 8) {
			Image("img-preview-error")
				.resizable()
				.frame(width: BadgeSettings.Dimension.messageImageWidth,
					   height: BadgeSettings.Dimension.messageImageHeight)
			Text(message)
				.font(.previewMessageText)
				.foregroundStyle(Color.theme.previewErrorTextColor)
				.multilineTextAlignment(.center)
		}
		.padding(.horizontal)
    }
}

#Preview {
	PreviewErrorView(message: "This is a error message statement. Fill here the same message that backend sends.")
}
