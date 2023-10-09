//
//  FortuneWheelView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 9/19/23.
//

import SwiftUI

struct FortuneWheelView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var rotationAngle: Double = 0.0
    @State private var activeIndex: Int?
    @State private var isSpinning: Bool = false
    
    let colors: [Color] = [.green, .red, .blue, .yellow, .green, .red, .blue, .red, .blue]
    let labels: [String] = ["Win $20 Off",
                            "Better Luck Next Time",
                            "Win 300 Bonus Points",
                            "Chance to win Free EarPod",
                            "Win 1000 Bonus Points",
                            "Better Luck Next Time",
                            "Win 20% Off",
                            "Better Luck Next Time",
                            "Win 300 Bonus Points"]
    
    var body: some View {
        VStack {
            HStack {
                Button {
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
                        Text("Spin a wheel!")
                            .font(.gameHeaderTitle)
                            
                        Text("Get a chance to win instant rewards!")
                            .font(.gameHeaderSubTitle)
                    }
                    .padding(30)
                    
                    Spacer()
                    ZStack {
                        // Fortune Wheel Segments
                        ZStack {
                            ForEach(0..<colors.count, id: \.self) { index in
                                let startAngle = (360.0 / Double(colors.count) * Double(index)) - 90.0
                                let endAngle = (360.0 / Double(colors.count) * Double(index + 1)) - 90.0

                                WheelSegment(startAngle: startAngle,
                                             endAngle: endAngle,
                                             color: colors[index],
                                             label: labels[index])
                            }
                        }
                        .rotationEffect(Angle(degrees: rotationAngle))
                        
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
                            spinWheel()
                        } label: {
                            isSpinning ? Text("") : Text("Tap to **SPIN**").foregroundColor(.white)
                        }
                        .frame(width: 70, height: 70)
                        .background(Color.theme.wheelIndicatorBackground)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        .disabled(isSpinning)  // Disable the button when spinning
                        
                    }
                    .frame(width: 300, height: 300)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Tap 'Spin' to play.")
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
                .foregroundColor(.white)
            }
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    
    func spinWheel() {
        if isSpinning { return }

        isSpinning = true

        let randomSpins = Double.random(in: 20...50)
        let randomDuration = Double.random(in: 5...10)
        
        let segmentAngle = 360.0 / Double(colors.count)
        let newAngle = rotationAngle + 360 * randomSpins
        let remainder = newAngle.truncatingRemainder(dividingBy: 360)
        let adjustment = (segmentAngle / 2) - (remainder.truncatingRemainder(dividingBy: segmentAngle))
        let adjustedAngle = newAngle + adjustment

        withAnimation(.easeOut(duration: randomDuration)) {
            rotationAngle = adjustedAngle
        }

        activeIndex = Int((remainder + adjustment) / segmentAngle)

        DispatchQueue.main.asyncAfter(deadline: .now() + randomDuration) {
            self.isSpinning = false
        }
    }

}

struct WheelSegment: View {
    var startAngle: Double
    var endAngle: Double
    var color: Color
    var label: String
    
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

struct FortuneWheelView_Previews: PreviewProvider {
    static var previews: some View {
        FortuneWheelView()
    }
}
