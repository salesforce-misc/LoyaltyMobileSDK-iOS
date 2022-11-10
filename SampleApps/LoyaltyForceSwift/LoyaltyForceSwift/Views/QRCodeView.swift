//
//  QRCodeView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI

struct QRCodeView: View {
    
    @Environment(\.dismiss) private var dismiss
    let QRCodeImage: UIImage
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                HStack {
                    Text("My Membership Code")
                        .font(.qrcodeTitle)
                    Spacer()
                    Image("ic-close")
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                
                Spacer()
                Rectangle()
                    .fill(.white)
                    .frame(width: 327, height: 346)
                    .cornerRadius(12)
                    .overlay(
                        VStack(spacing: 12) {
                            Image("img-profile-larger")
                            Text("Julia Green")
                                .font(.qrcodeTitle)
                            Text("QR Code")
                                .font(.qrcodeSubtitle)
                                .foregroundColor(Color.theme.superLightText)
                            //Spacer()
                            Image(uiImage: QRCodeImage)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .padding(.vertical)
                            //Spacer()
                            Text("Membership Number: 24345671")
                                .font(.qrcodeNumber)
                                .foregroundColor(Color.theme.superLightText)
                        }
                        .offset(y: -50)
                    )
                    .padding(.bottom)
                //Spacer()
                
                
                Text("Scan the QR code or enter your membership number at participating stores and online sites to earn and redeem points.")
                    .font(.qrcodeSubtitle)
                    .foregroundColor(Color.theme.superLightText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(DarkShortButton())
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct QRCodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let imageData = LoyaltyUtilities.generateQRCode(from: "sampleMembershipNumber", color: UIColor(Color.theme.accent)) ?? Data.init()
        let coloredImage = UIImage(data: imageData) ?? UIImage(systemName: "xmark.octagon") ?? UIImage()
        
        QRCodeView(QRCodeImage: coloredImage)
    }
}
