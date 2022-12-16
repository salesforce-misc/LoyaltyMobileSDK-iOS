//
//  TransactionCardView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct TransactionCardView: View {
    
    let transaction: TransactionHistory
    
    var body: some View {
        
        let points = transaction.getCurrencyPoints(currencyName: AppConstants.Config.rewardCurrencyName)
        let pointsString = points > 0 ? "+\(points) \(AppConstants.Config.rewardCurrencyNameShort)" : "\(points) \(AppConstants.Config.rewardCurrencyNameShort)"
        
        HStack(spacing: 0) {
            Assets.getTransactionsLogo(for: transaction.activity)
                .renderingMode(.template)
                .foregroundColor(Color.theme.textInactive)
                .frame(width: 63)
            VStack(spacing: 8) {
                HStack{
                    Text(transaction.activity)
                        .font(.transactionText)
                    Spacer()
                }
                HStack {
                    Text(transaction.activityDate.toDate()?.toString() ?? transaction.activityDate)
                        .font(.transactionDate)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                }
                
                
            }
            .frame(width: 180)
            Text(pointsString)
                .font(.transactionPoints)
                .foregroundColor(points < 0 ? Color.theme.negativePoints : Color.theme.points)
                .frame(width: 100)

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
        VStack {
            TransactionCardView(transaction: dev.transactions[0])
            TransactionCardView(transaction: dev.transactions[1])
        }
        
    }
}
