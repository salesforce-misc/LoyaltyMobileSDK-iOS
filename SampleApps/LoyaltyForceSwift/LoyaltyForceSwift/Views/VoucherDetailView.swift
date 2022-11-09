//
//  VoucherDetailView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/11/22.
//

import SwiftUI

struct VoucherDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color.white
            
            VStack(alignment: .leading) {
                Image("voucher2")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .overlay(alignment: .topTrailing) {
                        Image("ic-dismiss")
                            .padding()
                            .onTapGesture {
                                dismiss()
                            }
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("$50 Off at Nike")
                        .font(.voucherTitle)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Type: **Online stores**")
                        Text("Value: **$11**")
                        Text("Expiring on **05 Jan 2023**")
                        Text("Voucher Code:")
                    }
                    .font(.voucherText)
                    
                    let QRCodeImageData = LoyaltyUtilities.getQRCodeData(text: "84KFFFS") ?? Data.init()
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
                        Text("84KFFFS")
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

                    Text("**Details**\nDiscounts on a wide range of electronics and accessories from top brands like headphones, speakers, TVs, projectors, computers, cameras, small appliances and much more.")
                        .font(.voucherText)
                        .foregroundColor(Color.theme.superLightText)
                        .lineSpacing(5)
                    
                    HStack {
                        Spacer()
                        Button("Close") {
                            dismiss()
                        }
                        .buttonStyle(DarkShortButton())
                        Spacer()
                    }
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
        VoucherDetailView()
    }
}
