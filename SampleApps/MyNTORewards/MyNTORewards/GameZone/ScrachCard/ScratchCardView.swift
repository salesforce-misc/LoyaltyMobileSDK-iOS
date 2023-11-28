//
//  ScratchCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/3/23.
//

import SwiftUI

struct ScratchCardView: View {
	@StateObject var playGameViewModel = PlayGameViewModel()
	@EnvironmentObject private var routerPath: RouterPath
	@Environment(\.dismiss) var dismiss
	@State private var finishedScratching = false
	@State private var finishedPlaying = false
	@State var timer: Timer?
	let cardSize = CGSize(width: 289, height: 115)
	let backgroundSize = CGSize(width: 343, height: 199)
	
	var body: some View {
		if finishedPlaying {
			GamificationCongratsView()
		} else {
			VStack {
				backButton
				ZStack {
					Color.theme.backgroundPink
					VStack {
						titleView
						Spacer()
						scratchCardGame
						Spacer()
						descriptionView
						Spacer()
					}
					.foregroundColor(Color.theme.superLightText)
				}
				.cornerRadius(15, corners: [.topLeft, .topRight])
				.edgesIgnoringSafeArea(.bottom)
				.onChange(of: playGameViewModel.state, perform: { state in
					switch state {
					case .loaded:
						eraseWrapperView()
                        guard let reward = playGameViewModel.playedGameRewards?.first else { return }
						// Using timer instead of asyncAfter in order to have control to invalidate the timer to avoid navigation
						timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
							reward.rewardType == "NoReward" ? showBetterLuckNextTime() : showCongrats(offerText: reward.name)
						}
					default:
						// TODO: Handle failed loading scenario
						break
					}
				})
			}
		}
	}
	
	private func showCongrats(offerText: String) {
		self.routerPath.navigateFromGameZone(to: .gameZoneCongrats(offerText: offerText))
	}
	
	private func showBetterLuckNextTime() {
		self.routerPath.navigateFromGameZone(to: .gameZoneBetterLuck)
	}
	
	private func eraseWrapperView() {
		withAnimation(Animation.easeOut(duration: 1)) {
			self.finishedScratching = true
		}
	}
	
	private var backButton: some View {
		HStack {
			Button {
				// Invalidating the timer to avoid unintended navigation because of the timer
				timer?.invalidate()
				dismiss()
			} label: {
				Image("ic-backarrow")
			}
			.padding(.leading, 20)
			.padding(.bottom, 10)
			.frame(width: 30, height: 30)
			
			Spacer()
		}
	}
	
	private var titleView: some View {
		VStack(spacing: 10) {
			Text("Scratch and win!")
				.font(.gameHeaderTitle)
			
			Text("Get a chance to win instant rewards!")
				.font(.gameHeaderSubTitle)
		}
		.padding(30)
	}
	
	private var loadingView: some View {
		ProgressView()
			.tint(.white)
			.controlSize(.large)
			.frame(width: cardSize.width, height: cardSize.height)
			.background(Color.theme.accent)
	}
	
	private var rewardText: some View {
        Text(playGameViewModel.playedGameRewards?.first?.name ?? "--")
			.font(.largeTitle)
			.bold()
			.foregroundStyle(.white)
			.frame(width: cardSize.width, height: cardSize.height)
			.background(Color.theme.accent)
			.zIndex(finishedScratching ? 10 : 0)
	}
	
	private var scratchCardWrapperText: some View {
		Text(String(repeating: "SCRATCH TO WIN! ", count: 80))
			.font(Font.scratchText)
			.multilineTextAlignment(.center)
			.foregroundColor(Color.theme.scratchCardText)
			.rotationEffect(Angle(degrees: -45))
			.mask {
				Rectangle()
					.frame(width: cardSize.width, height: cardSize.height)
					.cornerRadius(10)
					.opacity(finishedScratching ? 0 : 1)
			}
			.opacity(finishedScratching ? 0 : 1)
	}
	
	private var scratchCardContentView: some View {
		ZStack {
			// Purple background with postage stamp border
			DottedBorderRectangle(width: backgroundSize.width,
								  height: backgroundSize.height,
								  color: Color.theme.accent)
			
			// Grey scratch card
			Rectangle()
				.fill(Color.theme.scratchCardBackground)
				.frame(width: cardSize.width, height: cardSize.height)
				.cornerRadius(10)
				.opacity(finishedScratching ? 0 : 1)
			
			// Text overlay
			scratchCardWrapperText
		}
	}
	
	private var scratchCardGame: some View {
		ScratchCardGame(cursorSize: 30, cardSize: cardSize, onFinish: $finishedScratching) {
			scratchCardContentView
		} overlayView: {
			// Reward text
			switch playGameViewModel.state {
			case .loaded:
				rewardText
			default:
				loadingView
			}
		}
		.animation(.linear(duration: 0.5), value: playGameViewModel.state)
		.environmentObject(playGameViewModel)
	}
	
	private var descriptionView: some View {
		VStack(spacing: 20) {
			Text("Scratch coupon to play")
				.font(.gameDescTitle)
			// swiftlint:disable line_length
			Text("This is a one time offer exclusively for you. This offer if declined may not be repeated. Please refer to the terms and conditions for more information.")
				.font(.gameDescText)
				.multilineTextAlignment(.center)
				.frame(width: 258)
			// swiftlint:enable line_length
		}
	}
}

struct ScratchCardGame<Content: View, OverlayView: View>: View {
	@EnvironmentObject var playGameViewModel: PlayGameViewModel
	let cursorSize: CGFloat
	let cardSize: CGSize
	@Binding var onFinish: Bool
	
	var content: Content
	var overlayView: OverlayView
	
	// For scratch efffect
	@State var startingPoint: CGPoint = .zero
	@State var points: [CGPoint] = []
	
	@State var scratchedArea: CGFloat = 0
	@State var totalArea: CGFloat = 0
	
	// For gesture update
	@GestureState var gestureLocation: CGPoint = .zero
	
	init(
		cursorSize: CGFloat,
		cardSize: CGSize,
		onFinish: Binding<Bool>,
		@ViewBuilder content: @escaping () -> Content,
		@ViewBuilder overlayView: @escaping () -> OverlayView) {
			self.cursorSize = cursorSize
			self.cardSize = cardSize
			self._onFinish = onFinish
			self.content = content()
			self.overlayView = overlayView()
	}
	
	var body: some View {
		ZStack {
			content
			overlayView
				.mask(
					maskingView()
				)
				.gesture(
					DragGesture()
						.updating($gestureLocation, body: { value, out, _ in
							out = value.location
							Task {
								if playGameViewModel.state != .loaded {
									await playGameViewModel.playGame(gameParticipantRewardId: "")
								}
							}
							DispatchQueue.main.async {
								
								// Update starting point and add user drag locations
								if startingPoint == .zero {
									startingPoint = value.location
								}
								
								points.append(value.location)
								// print(points)
							}
						})
						.onEnded({ value in
							// Consider both the points captured during dragging and the final value's start and end points
							let allPoints = points + [value.startLocation, value.location]
							
							// Calculate the scratched area, assuming each point covers an area equal to cursorSize^2
							scratchedArea = CGFloat(allPoints.count) * pow(cursorSize, 1.9)
							
							// Calculate the total overlayView area
							totalArea = cardSize.width * cardSize.height
							
							// Check if scratched area is closer to total area
							if scratchedArea >= totalArea {
								withAnimation(Animation.easeOut(duration: 1).delay(0.5)) {
									self.onFinish = true
								}
								// print("You should see the whole rewards!")
							}
							print("Scratched Area: \(scratchedArea), total area: \(totalArea)")
						})
					
				)
		}
	}
	
	@ViewBuilder
	func maskingView() -> some View {
		if onFinish {
			Rectangle().frame(width: cardSize.width, height: cardSize.height)
		} else {
			ScratchMask(points: points, startingPoint: startingPoint)
				.stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .round, lineJoin: .round))
		}
	}
}

// Scratch mash shape
// it will appear based on user gesture
struct ScratchMask: Shape {
	
	var points: [CGPoint]
	var startingPoint: CGPoint
	
	func path(in rect: CGRect) -> Path {
		
		return Path { path in
			path.move(to: startingPoint)
			path.addLines(points)
			
		}
	}
}

struct DottedBorderRectangle: View {
	var width: CGFloat
	var height: CGFloat
	var dotSize: CGSize = CGSize(width: 16, height: 16)
	var color: Color
	let spacing: CGFloat = 8
	
	var body: some View {
		ZStack {
			Rectangle()
				.fill(color)
				.frame(width: width, height: height)
			
			// Top dots
			HStack(alignment: .top, spacing: spacing) {
				ForEach(0..<Int(width / (dotSize.width + spacing)), id: \.self) { _ in
					Capsule()
						.fill(Color.theme.scratchCardDotsBackground)
						.frame(width: dotSize.width, height: dotSize.height)
						.offset(y: -height / 2)
				}
			}
			
			// Bottom dots
			HStack(alignment: .bottom, spacing: spacing) {
				ForEach(0..<Int(width / (dotSize.width + spacing)), id: \.self) { _ in
					Capsule()
						.fill(Color.theme.scratchCardDotsBackground)
						.frame(width: dotSize.width, height: dotSize.height)
						.offset(y: height / 2)
				}
			}
		}
	}
}

#Preview {
	ScratchCardView()
}
