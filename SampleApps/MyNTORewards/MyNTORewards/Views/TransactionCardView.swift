//
//  TransactionCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct TransactionCardView: View {
    
    let transaction: TransactionJournal
    
    var body: some View {
        
        let points = transaction.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName)
        let pointsString = points > 0 ? "+\(points) \(AppSettings.Defaults.rewardCurrencyNameShort)" : "\(points) \(AppSettings.Defaults.rewardCurrencyNameShort)"
        
        HStack(spacing: 10) {
            Spacer()
            
            Assets.getTransactionsLogo(for: transaction.journalTypeName)
                .renderingMode(.template)
                .foregroundColor(Color.theme.textInactive)
            
            VStack(spacing: 8) {
                HStack{
                    Text(transaction.journalTypeName)
                        .font(.transactionText)
                    Spacer()
                }
                HStack {
                    Text(transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat)?.toString() ?? transaction.activityDate)
                        .font(.transactionDate)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                }
                
                
            }

            Text(pointsString)
                .font(.transactionPoints)
                .foregroundColor(points < 0 ? Color.theme.negativePoints : Color.theme.points)
            
            Spacer()

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
