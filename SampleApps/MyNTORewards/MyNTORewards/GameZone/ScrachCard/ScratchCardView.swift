//
//  ScratchCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/3/23.
//

import SwiftUI

struct ScratchCardView: View {
    @Environment(\.dismiss) var dismiss
    let rewardText = "20% OFF"
    let cardSize = CGSize(width: 289, height: 115)
    let backgroundSize = CGSize(width: 343, height: 199)
    @State var isFinished: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("ic-backarrow")
                }
                .padding(.leading, 20)
                .padding(.bottom, 10)
                .frame(width: 30, height: 30)
                
                Spacer()
            }
            ZStack {
                Color.theme.backgroundPink
                VStack {
                    VStack(spacing: 10) {
                        Text("Scratch and win!")
                            .font(.gameHeaderTitle)
                            
                        Text("Get a chance to win instant rewards!")
                            .font(.gameHeaderSubTitle)
                    }
                    .padding(30)
                    
                    Spacer()
                    
                    ScratchCardGame(cursorSize: 30, cardSize: cardSize, onFinish: $isFinished) {
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
                                .opacity(isFinished ? 0 : 1)
   
                            Text(String(repeating: "SCRATCH TO WIN! ", count: 80))
                                .font(Font.scratchText)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.theme.scratchCardText)
                                .rotationEffect(Angle(degrees: -45))
                                .mask {
                                    Rectangle()
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .cornerRadius(10)
                                        .opacity(isFinished ? 0 : 1)
                                }
                                .opacity(isFinished ? 0 : 1)
                        }
                    } overlayView: {
                        // Reward text
                        Text(rewardText)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: cardSize.width, height: cardSize.height)
                            .background(Color.theme.accent)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
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
                    Spacer()
                }
                .foregroundColor(Color.theme.superLightText)
            }
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }
}

struct ScratchCardGame<Content: View, OverlayView: View>: View {
    
    let cursorSize: CGFloat
    let cardSize: CGSize
    @Binding var onFinish: Bool
    
    var content: Content
    var overlayView: OverlayView
    
    // For scratch efffect
    @State var startingPoint: CGPoint = .zero
    @State var points: [CGPoint] = []
    
    // For gesture update
    @GestureState var gestureLocation: CGPoint = .zero
    
    init(cursorSize: CGFloat,
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
                    ScratchMask(points: points, startingPoint: startingPoint)
                        .stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .butt, lineJoin: .bevel))
                )
                .gesture(
                    DragGesture()
                        .updating($gestureLocation, body: { value, out, _ in
                            out = value.location
                            
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
                            let scratchedArea = CGFloat(allPoints.count) * pow(cursorSize, 2)
                            
                            // Calculate the total overlayView area
                            let totalArea = cardSize.width * cardSize.height
                            
                            // Check if scratched area is closer to total area
                            if scratchedArea >= totalArea {
                                withAnimation(Animation.easeOut(duration: 1).delay(0.5)) {
                                    self.onFinish = true
                                }
                                // print("You should see the whole rewards!")
                            }
                        })
                    
                )
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
