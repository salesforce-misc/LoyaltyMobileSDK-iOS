//
//  RewardPointsCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/11/22.
//

import SwiftUI
import UIKit

struct RewardPointsCardView: View {
    
    let status: String = "GOLD"
    let points: String = "17850"
    let membershipNumber: String = "24345671"
    let expiringPoint: String = "100"
    let expiringDate: String = "Oct 20 2022"
    let currentTierPoints: Int = 4000
    let currentTierLimit: Int = 6000
    
    @State var showQRCode: Bool = false
    
    var body: some View {
        
        let imageData = LoyaltyUtilities.generateQRCode(from: membershipNumber, color: UIColor(Color.theme.accent)) ?? Data.init()
        let coloredImage = UIImage(data: imageData) ?? UIImage(systemName: "xmark.octagon") ?? UIImage()
        
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 220)
                .padding(.horizontal)
                .foregroundColor(Color.theme.accent)
                .overlay(
                    ellipseView
                        .offset(x: 260, y: -85)
                )
                .overlay(
                    ellipseView
                        .offset(x: 190, y: 120)
                )
                .clipped()
                .overlay(alignment: .topTrailing) {
                    Image("ic-logo-card")
                        .padding(.top, 20)
                        .padding(.trailing, 35)
                }
                .overlay(alignment: .topLeading) {
                    Text(status)
                        .font(.transactionPoints)
                        .padding()
                        .background(Color.theme.memberStatus)
                        .frame(width: 72, height: 26)
                        .cornerRadius(30)
                        .padding(.top, 15)
                        .padding(.leading, 35)

                }
                .overlay(alignment: .bottomLeading) {
                    Text("REWARD POINTS")
                        .font(.transactionPoints)
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                        .padding(.bottom, 15)
                }
                .overlay(alignment: .bottomTrailing) {
                    
                    Button {
                        showQRCode.toggle()
                    } label: {
                        Image(uiImage: coloredImage)
                            .resizable()
                            .frame(width: 46, height: 46)
                            .cornerRadius(4)
                            .padding(.trailing, 35)
                            .padding(.bottom, 15)
                    }
                    .sheet(isPresented: $showQRCode) {
                        QRCodeView(QRCodeImage: coloredImage)
                    }
                }
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(points)
                            .font(.cardPointsText)
                            
                        Text("\(expiringPoint) points expiring on \(expiringDate)")
                            .font(.cardExpiringPointsText)
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 35)
                    
                }
            
                VStack(spacing: 0) {
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            Capsule()
                                .fill(Color.theme.progressBarBackground)
                            Capsule()
                                .fill(Color.theme.accent)
                                .frame(maxWidth: CGFloat(Float(currentTierPoints) / Float(currentTierLimit)) * (geo.size.width))
                        }
                        .frame(height: 6)
                    }
                    .frame(height: 6)
                
                    HStack {
                        Text("\(Text(String(currentTierPoints)).foregroundColor(Color.theme.accent))/\(String(currentTierLimit))")
                            .foregroundColor(Color.theme.tierPoints)
                            .font(.tierPointsText)
                        Spacer()
                        Text("Tier Expiring on Dec 31")
                            .font(.tierPointsNotes)
                    }
                    .padding(.vertical)
            }
            .padding()
            
        }
    }
    
    var ellipseView: some View {
        Ellipse()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.93, green: 0.88, blue: 0.98), Color(red: 0.93, green: 0.88, blue: 0.98)]), startPoint: .top, endPoint: .bottom))
            .opacity(0.10)
            .frame(width: 421.27, height: 359.37)
    }
    
    func setImageColor(image: UIImage, color: UIColor) -> UIImage {
        var newImage = image
        newImage = newImage.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: newImage)
        imageView.tintColor = color
        return imageView.image ?? image
    }
}

struct RewardPointsCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardPointsCardView()
    }
}
