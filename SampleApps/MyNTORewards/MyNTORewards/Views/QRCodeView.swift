//
//  QRCodeView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/12/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct QRCodeView: View {
    
    @Environment(\.dismiss) private var dismiss
    let QRCodeImage: UIImage
    let name: String
    let membershipNumber: String
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                HStack {
                    Text("My Membership Code")
                        .font(.qrcodeTitle)
                        .accessibilityIdentifier(AppAccessibilty.QRCode.title)
                    Spacer()
                    Image("ic-close")
                        .accessibilityIdentifier(AppAccessibilty.QRCode.closeImage)
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
                            Image("img-profile-adam")
                                .accessibilityIdentifier(AppAccessibilty.QRCode.profileImage)
                            Text(name)
                                .font(.qrcodeTitle)
                                .accessibilityIdentifier(AppAccessibilty.QRCode.userName)
                            Text("QR Code")
                                .font(.qrcodeSubtitle)
                                .foregroundColor(Color.theme.superLightText)
                                .accessibilityIdentifier(AppAccessibilty.QRCode.qrCodeText)
                            //Spacer()
                            Image(uiImage: QRCodeImage)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .padding(.vertical)
                                .accessibilityIdentifier(AppAccessibilty.QRCode.qrImage)
                            //Spacer()
                            Text("Membership Number: \(membershipNumber)")
                                .font(.qrcodeNumber)
                                .foregroundColor(Color.theme.superLightText)
                                .accessibilityIdentifier(AppAccessibilty.QRCode.membershipNumber)
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
                    .accessibilityIdentifier(AppAccessibilty.QRCode.qrDescription)
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .accessibilityIdentifier(AppAccessibilty.QRCode.closeButton)
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
        
        QRCodeView(QRCodeImage: coloredImage, name: "Julia Green", membershipNumber: "24345671")
    }
}
