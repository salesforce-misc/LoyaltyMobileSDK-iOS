//
//  VoucherCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VoucherCardView: View {
    
    @EnvironmentObject private var voucherVM: VoucherViewModel
    
    @State var showVoucherDetailView = false
    let voucher: VoucherModel
    
    var body: some View {
        
        VStack {
            AsyncImageView(imageUrl: voucher.image)
                .frame(width: 165, height: 92)
                .cornerRadius(5, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 10) {
                Text(voucher.name)
                    .font(.redeemTitle)
                
                VStack(alignment: .leading, spacing: 4) {
//                    Text("Online stores")
//                    Text("Value: **$11**")
                    if let voucherValue = voucher.getVoucherValue() {
                        voucherValue
                    }
                    Text("Expiring on **\(voucher.expirationDate)**")
                }
                .font(.offerText)
                
                if voucher.status == "Redeemed" {
                    Text("Redeemed")
                        .font(.voucherButtonText)
                        .foregroundColor(Color.theme.redeemedButtonText)
                        .frame(width: 145, height: 32)
                        .background(Color.theme.redeemedButtonBackground)
                        .cornerRadius(10)
                        .padding(.top, 6)
                }
                if voucher.status == "Expired" {
                    Text("Expired")
                        .font(.voucherButtonText)
                        .foregroundColor(Color.theme.expiredButtonText)
                        .frame(width: 145, height: 32)
                        .background(Color.theme.expiredBackgroundText)
                        .cornerRadius(10)
                        .padding(.top, 6)
                }
                if voucher.status == "Issued" {
                    if let voucherCode = voucher.code {
                        Text(voucherCode)
                            .font(.profileSubtitle)
                            .foregroundColor(Color.theme.voucherCode)
                            .frame(width: 145, height: 32)
                            .background(Color.theme.voucherBackground)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2.0]))
                                    .foregroundColor(Color.theme.voucherBorder)
                            )
                            .padding(.top, 6)
                    }
                    
                }
                
            }
            .padding(.horizontal, 10)
            Spacer()

        }
        .frame(width: 165, height: 232)
        .background(Color.white)
        .cornerRadius(10)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(
                    color: Color.gray.opacity(0.4),
                    radius: 10,
                    x: 0,
                    y: 0
                 )
        )
        .onTapGesture {
            showVoucherDetailView.toggle()
        }
        .sheet(isPresented: $showVoucherDetailView) {
            VoucherDetailView(voucher: voucher)
        }
        
    }
}

struct VoucherCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 15) {
            VoucherCardView(voucher: dev.voucher1)
                .environmentObject(dev.voucherVM)
            VoucherCardView(voucher: dev.voucher2)
                .environmentObject(dev.voucherVM)
        }
        
    }
}
