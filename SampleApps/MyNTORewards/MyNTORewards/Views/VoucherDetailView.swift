//
//  VoucherDetailView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/11/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct VoucherDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @State var isCodeCopiedAlertPresent = false
    let voucher: VoucherModel
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                
                LoyaltyAsyncImage(url: voucher.voucherImageUrl, content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    ProgressView()
                })
                .accessibilityIdentifier(AppAccessibilty.Voucher.image)
                .frame(maxWidth: .infinity, maxHeight: 220)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    Image("ic-dismiss")
                        .accessibilityIdentifier(AppAccessibilty.Voucher.dismissButton)
                        .padding()
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(voucher.voucherDefinition)
                        .font(.voucherTitle)
                        .accessibilityIdentifier(AppAccessibilty.Voucher.name)

                    VStack(alignment: .leading, spacing: 5) {
                        if let voucherValue = voucher.getVoucherValue() {
                            voucherValue
                        }
                        Text("Expiring on **\(voucher.expirationDate)**")
                            .accessibilityIdentifier(AppAccessibilty.Voucher.endDate)
                    }
                    .font(.voucherText)
                    let voucherCode = voucher.voucherCode
                    let QRCodeImageData = LoyaltyUtilities.getQRCodeData(text: voucherCode) ?? Data.init()
                    let QRCodeImage = UIImage(data: QRCodeImageData) ?? UIImage(systemName: "xmark.octagon.fill") ?? UIImage()
                    
                    HStack {
                        Spacer()
                        Image(uiImage: QRCodeImage)
                            .resizable()
                            .accessibilityIdentifier(AppAccessibilty.Voucher.qrCode)
                            .frame(width: 110, height: 110)
                        Spacer()
                    }

                    HStack {
                        Spacer()
                        HStack {
                            Text(voucherCode)
                                .accessibilityIdentifier(AppAccessibilty.Voucher.voucherCode)
                                .font(.profileSubtitle)
                                .foregroundColor(Color.theme.voucherCode)
                                .padding(.leading, 8)
                            Spacer()
                            Image("ic-copy")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing, 8)
                        }
                        .frame(width: 145.8, height: 32)
                        .background(Color.theme.voucherBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2.0]))
                                .foregroundColor(Color.theme.voucherBorder)
                        )
                        .padding(.top, 6)
                        .onTapGesture {
                            let pasteboard = UIPasteboard.general
                            pasteboard.string = voucherCode
                            isCodeCopiedAlertPresent = true
                        }
                        .alert(isPresented: $isCodeCopiedAlertPresent) {
                            Alert(title: Text(AppSettings.Vouchers.codeSuccessfullyCopied))
                        }
                        Spacer()
                    }
                    
                    if let details = voucher.description {
                        Text("**Details**\n\(details)")
                            .accessibilityIdentifier(AppAccessibilty.Voucher.description)
                            .font(.voucherText)
                            .foregroundColor(Color.theme.superLightText)
                            .lineSpacing(5)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Close") {
                            dismiss()
                        }
                        .accessibilityIdentifier(AppAccessibilty.Voucher.closeButton)
                        .buttonStyle(DarkShortButton())
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .zIndex(3.0)
        
    }
}

struct VoucherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VoucherDetailView(voucher: dev.voucher1)
            .environmentObject(dev.voucherVM)
			.environmentObject(dev.imageVM)
    }
}
