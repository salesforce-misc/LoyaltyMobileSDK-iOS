//
//  UIView+Shimmer.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 08/11/23.
//

import SwiftUI

extension View {
	@ViewBuilder
	func shimmer(_ config: ShimmerConfig, enabled: Bool = true) -> some View {
		if enabled {
			self
				.modifier(ShimmerEffectHelper(config: config))
		} else {
			self
		}
			
	}
}

private struct ShimmerEffectHelper: ViewModifier {
	var config: ShimmerConfig
	@State private var moveTo: CGFloat = -0.7
	func body(content: Content) -> some View {
		content
			.hidden()
			.overlay {
				Rectangle()
					.fill(config.tint)
					.mask {
						content
					}
					.overlay {
						GeometryReader {
							let size = $0.size
							shimmerView(content: content, xOffset: size.width * moveTo)
						}
						.mask {
							content
						}
					}
					.overlay {
						GeometryReader {
							let size = $0.size
							shimmerView(content: content, xOffset: size.width * moveTo + size.width/2)
						}
						.mask {
							content
						}
					}
					.onAppear {
						DispatchQueue.main.async {
							moveTo = 0.7
						}
					}
					.animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
			}
	}
	
	func shimmerView(content: Content, xOffset: CGFloat) -> some View {
		Rectangle()
			.fill(config.highlight)
			.mask {
				Rectangle()
					.fill(
						.linearGradient(colors: [
							.white.opacity(0),
							config.highlight.opacity(config.highlightOpacity),
							.white.opacity(0)
						], startPoint: .top, endPoint: .bottom)
					)
					.blur(radius: config.blur)
					.rotationEffect(.init(degrees: -70))
					.offset(x: xOffset)
			}
	}
}

struct ShimmerConfig {
	var tint: Color
	var highlight: Color
	var blur: CGFloat = 0
	var highlightOpacity: CGFloat = 1
	var speed: CGFloat = 2
}
