//
//  FortuneWheelView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/19/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct FortuneWheelView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var routerPath: RouterPath
    @EnvironmentObject var gameViewModel: GameZoneViewModel
    @EnvironmentObject var rootVM: AppRootViewModel
    @State private var rotationAngle: Double = 0.0
    @State private var activeIndex: Int?
    @State private var isSpinning: Bool = false
	@State private var userStartedSpinning = false
    @State private var showAlertForError = false
	@State var timer: Timer?
    var viewModel = PlayGameViewModel()
    var gameDefinitionModel: GameDefinition?
	
    var body: some View {
        VStack {
            HStack {
                Button {
                    // Invalidating the timer to avoid unintended navigation because of the timer
                    timer?.invalidate()
                    isSpinning ? nil : dismiss()
                } label: {
                    Image("ic-backarrow")
                }
                .padding(.leading, 20)
                .padding(.bottom, 10)
                .frame(width: 30, height: 30)
                
                Spacer()
            }
            ZStack {
                Color.theme.accent
                VStack {
                    VStack(spacing: 10) {
                        Text(StringConstants.Gamification.spinaWheelHeaderLabel)
                            .font(.gameHeaderTitle)
                        
                        Text(StringConstants.Gamification.spinaWheelSubHeaderLabel)
                            .font(.gameHeaderSubTitle)
                    }
                    .padding(30)
                    
                    Spacer()
                    ZStack {
                        // Fortune Wheel Segments
                        ZStack {
                            if let colors: [Color] = viewModel.getWheelColors(gameModel: gameDefinitionModel),
							   let labels: [LocalizedStringKey] = gameDefinitionModel?.gameRewards.map({LocalizedStringKey($0.name)}) {
                                ForEach(0..<colors.count, id: \.self) { index in
                                    let startAngle = (360.0 / Double(colors.count) * Double(index)) - 90.0
                                    let endAngle = (360.0 / Double(colors.count) * Double(index + 1)) - 90.0
                                    
                                    WheelSegment(startAngle: startAngle,
                                                 endAngle: endAngle,
                                                 color: colors[index],
                                                 label: labels[index])
                                }
                            }
                        }
						.overlay {
							ZStack {
								Circle()
									.strokeBorder(Color.theme.fortuneWheelStrokeColor, lineWidth: 5)
									.frame(width: 316, height: 316)
								Circle()
									.strokeBorder(Color.theme.fortuneWheelSecondaryStrokeColor, lineWidth: 1)
									.frame(width: 307, height: 307)
							}
						}
                        .rotationEffect(Angle(degrees: rotationAngle))
                        .animation(isSpinning ? Animation.easeOut(duration: gameDefinitionModel?.timeoutDuration ?? 15)
                            .delay(0)
                            .repeatForever(autoreverses: false) : .default, value: isSpinning)
                        
                        // Triangle Arrow Indicator
                        ZStack {
                            Triangle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)  // Increase these dimensions by the stroke width
                                .offset(y: -40)
                            
                            Triangle()
                                .fill(Color.theme.wheelIndicatorBackground)
                                .frame(width: 60, height: 60)
                                .offset(y: -35)
                        }
                        
                        // Spin Button
                        Button {
                            playGame()
                        } label: {
                            userStartedSpinning ?
                            Text(StringConstants.Gamification.tapSpinButtonLabel).foregroundColor(Color.theme.wheelIndicatorBackground) :
                            Text(StringConstants.Gamification.tapSpinButtonLabel).foregroundColor(.white)
                            
                        }
                        .frame(width: 70, height: 70)
                        .background(Color.theme.wheelIndicatorBackground)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        .disabled(userStartedSpinning)  // Disable the button when spinning
                        
                    }
                    .frame(width: 300, height: 300)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text((StringConstants.Gamification.tapSpinaWheeltoPlayLabel))
                            .font(.gameDescTitle)
                        Text(StringConstants.Gamification.spinaWheelBodyLabel)
                            .font(.gameDescText)
                            .multilineTextAlignment(.center)
                            .frame(width: 258)
                    }
                    Spacer()
                }
                .foregroundColor(.white)
            }
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showAlertForError) {
                   Alert(
                       title: Text("Error"),
                       message: Text("Something went wrong. Please try again"),
                       dismissButton: .default(
                           Text("Dismiss")
                       )
                   )
               }
        }
    }
    
    func playGame() {
        Task {
            guard let gameParticipantRewardId = gameDefinitionModel?.participantGameRewards.first?.gameParticipantRewardID else {return}
            spinWheel()
            userStartedSpinning = true
            await viewModel.playGame(gameParticipantRewardId: gameParticipantRewardId)
            if viewModel.state == .loaded, let rewardId = viewModel.issuedRewardId {
                guard let colors: [Color] = viewModel.getWheelColors(gameModel: gameDefinitionModel) else { return }
                    if let index = gameDefinitionModel?.gameRewards.firstIndex(where: {$0.gameRewardId == rewardId}) {
                        let segmentAngle = 360.0 / Double(colors.count)
                        let stopLocationAngle = segmentAngle * (Double(index)+1.0) - (segmentAngle / 2)
                        rotationAngle = -stopLocationAngle
                        activeIndex = index + 1
                        stopWheel()
                        showNextScreenBasedonReward()
                    } else {
                        // No matching reward found handle Error
                        handleErrorCase()
                    }
            } else {
                // handle Error
                handleErrorCase()
            }
        }
    }
    
    func handleErrorCase() {
        rotationAngle = 0
        activeIndex =  1
        stopWheel()
        userStartedSpinning = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showAlertForError = true
        }
    }
    
    func showNextScreenBasedonReward() {
        // Using timer instead of asyncAfter in order to have control to invalidate the timer to avoid navigation
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            if let reward = viewModel.playedGameRewards?.first {
                if reward.rewardType == "NoReward" {
                    self.routerPath.navigateFromGameZone(to: .gameZoneBetterLuck)
                } else {
                    self.routerPath.navigateFromGameZone(to: .gameZoneCongrats(offerText: reward.name))
                }
            }
        }
        Task {
            Logger.debug("Reloading available Games...")
            do {
                try await gameViewModel.reload(id: rootVM.member?.membershipNumber ?? "", number: "")
                Logger.debug("loaded available Games...")
                
            } catch {
                Logger.error("Reload Available Games Error: \(error)")
            }
        }
    }
    
    func stopWheel() {
        self.isSpinning = false
    }
    
    func spinWheel() {
        if isSpinning { return }
        guard let colors: [Color] = viewModel.getWheelColors(gameModel: gameDefinitionModel) else { return }

        isSpinning = true

        let randomSpins = Double.random(in: 20...50)
        let segmentAngle = 360.0 / Double(colors.count)
        let newAngle = rotationAngle + 360 * randomSpins
        let remainder = newAngle.truncatingRemainder(dividingBy: 360)
        let adjustment = (segmentAngle / 2) - (remainder.truncatingRemainder(dividingBy: segmentAngle))
        let adjustedAngle = newAngle + adjustment
        rotationAngle = adjustedAngle
        activeIndex = Int((remainder + adjustment) / segmentAngle)
    }
}

struct WheelSegment: View {
    var startAngle: Double
    var endAngle: Double
    var color: Color
    var label: LocalizedStringKey
    
    var body: some View {
        let p = Path { path in
            path.move(to: CGPoint(x: 150, y: 150))
            path.addArc(center: .init(x: 150, y: 150),
                        radius: 150,
                        startAngle: .init(degrees: startAngle),
                        endAngle: .init(degrees: endAngle),
                        clockwise: false)
            path.closeSubpath()
        }
        
        let textAngle = (startAngle + endAngle) / 2 // Midpoint angle of the segment
        let radius: CGFloat = 120 // Adjust this value based on where you want to place the text
        
        let xOffset = cos(textAngle * .pi / 180) * Double(radius)
        let yOffset = sin(textAngle * .pi / 180) * Double(radius)

        // Calculate the maximum width the text can occupy
        let maxTextWidth: CGFloat = 60 // Example value, adjust based on your design

        return ZStack {
            p.fill(color)
                .overlay(p.stroke(Color.white, lineWidth: 5))

            // Adjusted text view
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .frame(width: maxTextWidth)
                .rotationEffect(Angle(degrees: textAngle + 90))
                .offset(x: xOffset, y: yOffset)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let heightFactor: CGFloat = 0.8 // Reduce height by adjusting this factor (1.0 is full height)
        let widthFactor: CGFloat = 1.02 // Increase width by adjusting this factor (1.0 is full width)

        let midX = rect.midX
        let minY = rect.minY + (rect.height * (1 - heightFactor) / 2)
        let maxY = rect.maxY - (rect.height * (1 - heightFactor) / 2)
        let minX = rect.minX + (rect.width * (1 - widthFactor) / 2)
        let maxX = rect.maxX - (rect.width * (1 - widthFactor) / 2)

        path.move(to: CGPoint(x: midX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: midX, y: minY))
        return path
    }
}
