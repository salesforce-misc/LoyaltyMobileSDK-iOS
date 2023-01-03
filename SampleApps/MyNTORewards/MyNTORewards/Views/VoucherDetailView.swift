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
    let voucher: VoucherModel
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                
                AsyncImageWithAuth(url: voucher.image, content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    ProgressView()
                })
                .frame(maxWidth: .infinity, maxHeight: 220)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    Image("ic-dismiss")
                        .padding()
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(voucher.name)
                        .font(.voucherTitle)

                    VStack(alignment: .leading, spacing: 5) {
                        if let voucherValue = voucher.getVoucherValue() {
                            voucherValue
                        }
                        Text("Expiring on **\(voucher.expirationDate)**")
                    }
                    .font(.voucherText)
                    
                    if let voucherCode = voucher.code {
                        let QRCodeImageData = LoyaltyUtilities.getQRCodeData(text: voucherCode) ?? Data.init()
                        let QRCodeImage = UIImage(data: QRCodeImageData) ?? UIImage(systemName: "xmark.octagon.fill") ?? UIImage()
                        
                        HStack {
                            Spacer()
                            Image(uiImage: QRCodeImage)
                                .resizable()
                                .frame(width: 110, height: 110)
                            Spacer()
                        }

                        HStack {
                            Spacer()
                            Text(voucherCode)
                                .font(.profileSubtitle)
                                .foregroundColor(Color.theme.voucherCode)
                                .frame(width: 145.8, height: 32)
                                .background(Color.theme.voucherBackground)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2.0]))
                                        .foregroundColor(Color.theme.voucherBorder)
                                )
                                .padding(.top, 6)
                            Spacer()
                        }
                    }
                    
                    if let details = voucher.description {
                        Text("**Details**\n\(details)")
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
    }
}
