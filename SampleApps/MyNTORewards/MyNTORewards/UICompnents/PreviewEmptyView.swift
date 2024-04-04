//
//  PreviewEmptyView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 01/04/24.
//

import SwiftUI

struct PreviewEmptyView: View {
	let message: String
    var body: some View {
		VStack(spacing: 8) {
			Image("img-preview-empty")
				.resizable()
				.frame(width: BadgeSettings.Dimension.messageImageWidth,
					   height: BadgeSettings.Dimension.messageImageHeight)
			Text(message)
				.font(.previewMessageText)
				.foregroundStyle(Color.theme.accent)
		}
		.padding(.horizontal)
    }
}

#Preview {
	PreviewEmptyView(message: "After you receive a badge, you will see it here.")
}
