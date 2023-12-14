//
//  VoucherCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct VoucherCardView: View {
    
    @EnvironmentObject private var voucherVM: VoucherViewModel
    
    @State var showVoucherDetailView = false
    @State var isCodeCopiedAlertPresent = false
    let accessibilityID: String
    let voucher: VoucherModel
    
    var body: some View {
        
        VStack {
            LoyaltyAsyncImage(url: voucher.voucherImageUrl, content: { image in
                image
                    .resizable()
                    .scaledToFill()
            }, placeholder: {
                ProgressView()
            })
            .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.image)
            .frame(width: 165, height: 92)
            .cornerRadius(5, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 10) {
                Text(voucher.voucherDefinition)
                    .font(.redeemTitle)
                    .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.name)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let voucherValue = voucher.getVoucherValue() {
                        voucherValue
                    } else {
                        Text("")
                    }
                    Text("Expiring on **\(voucher.expirationDate)**")
                        .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.endDate)
                }
                .font(.offerText)
                
                Group {
                    if voucher.status == "Redeemed" {
                        Text("Redeemed")
                            .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.status)
                            .font(.voucherButtonText)
                            .foregroundColor(Color.theme.redeemedButtonText)
                            .frame(width: 145, height: 32)
                            .background(Color.theme.redeemedButtonBackground)
                            .cornerRadius(10)
                            .padding(.top, 6)
                    }
                    if voucher.status == "Expired" {
                        Text("Expired")
                            .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.status)
                            .font(.voucherButtonText)
                            .foregroundColor(Color.theme.expiredButtonText)
                            .frame(width: 152, height: 32)
                            .background(Color.theme.expiredBackgroundText)
                            .cornerRadius(10)
                            .padding(.top, 6)
                    }
                    if voucher.status == "Issued" {
                        let voucherCode = voucher.voucherCode
                        HStack {
                            Text(voucherCode)
                                .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Voucher.status)
                                .font(.profileSubtitle)
                                .foregroundColor(Color.theme.voucherCode)
                                .padding(.leading, 8)
                            Spacer()
                            Image("ic-copy")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing, 8)
                        }
                        .frame(width: 152, height: 32)
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
			if voucher.status == "Issued" {
				showVoucherDetailView.toggle()
			}
        }
        .sheet(isPresented: $showVoucherDetailView) {
            VoucherDetailView(voucher: voucher)
        }
        
    }
}

struct VoucherCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 15) {
            VoucherCardView(accessibilityID: "id", voucher: dev.voucher1)
                .environmentObject(dev.voucherVM)
				.environmentObject(dev.imageVM)
            VoucherCardView(accessibilityID: "id", voucher: dev.voucher2)
                .environmentObject(dev.voucherVM)
				.environmentObject(dev.imageVM)
        }
        
    }
}
