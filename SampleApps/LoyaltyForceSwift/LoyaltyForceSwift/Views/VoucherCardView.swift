//
//  VoucherCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VoucherCardView: View {
    var body: some View {
        
        VStack {
            Image("voucher2")
                .resizable()
                .scaledToFill()
                .frame(width: 165, height: 92)
                .cornerRadius(5, corners: [.topLeft, .topRight])
            VStack(alignment: .leading, spacing: 10) {
                Text("$50 Off at Nike")
                    .font(.redeemTitle)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Online stores")
                    Text("Blance: **$11**")
                    Text("Valid till: **05 Jan 2023**")
                }
                .font(.offerText)
                
                Text("84KFFFS")
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
                Spacer()
            }

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
    }
}

struct VoucherCardView_Previews: PreviewProvider {
    static var previews: some View {
        VoucherCardView()
    }
}
