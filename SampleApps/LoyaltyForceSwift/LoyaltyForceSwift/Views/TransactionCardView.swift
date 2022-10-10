//
//  TransactionCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct TransactionCardView: View {
    var body: some View {
        
        HStack(spacing: 0) {
            Image("wallet")
                .frame(width: 63)
                //.background(.pink)
            VStack(spacing: 8) {
                HStack{
                    Text("Promotion Enrollment")
                        .font(.transactionText)
                    Spacer()
                }
                HStack {
                    Text("05 June 2022")
                        .font(.transactionDate)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                }
                
                
            }
            .frame(width: 180)
            //.background(.green)
            Text("+1500 Pts")
                .font(.transactionPoints)
                .foregroundColor(Color.theme.points)
                .frame(width: 100)
                //.background(.blue)

        }
        .frame(width: 343, height: 66)
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

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCardView()
    }
}
