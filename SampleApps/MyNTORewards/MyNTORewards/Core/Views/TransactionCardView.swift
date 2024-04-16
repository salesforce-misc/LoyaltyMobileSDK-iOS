//
//  TransactionCardView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI
import LoyaltyMobileSDK

struct TransactionCardView: View {
    let accessibilityID: String
    let transaction: TransactionJournal
    
    var body: some View {
        
        let points = transaction.getCurrencyPoints(currencyName: AppSettings.shared.getRewardCurrencyName())
        // swiftlint:disable line_length
        let roundedPoints = String(format: "%.2f", points)
        let pointsString = Int(points) >= 0 ? "+\(roundedPoints) \(AppSettings.shared.getRewardCurrencyNameShort())" : "\(roundedPoints) \(AppSettings.shared.getRewardCurrencyNameShort())"
        // swiftlint:enable line_length
        
        HStack(spacing: 10) {
            Spacer()
            
            Assets.getTransactionsLogo(for: transaction.journalTypeName)
                .renderingMode(.template)
                .foregroundColor(Color.theme.textInactive)
                .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Transaction.logo)
            
            VStack(spacing: 8) {
                HStack {
                    Text(transaction.journalTypeName)
                        .font(.transactionText)
                        .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Transaction.name)
                    Spacer()
                }
                HStack {
                    Text(transaction.activityDate.toDate(withFormat: AppSettings.Defaults.apiDateFormat)?.toString() ?? transaction.activityDate)
                        .accessibilityIdentifier(accessibilityID + "_" + AppAccessibilty.Transaction.date)
                        .font(.transactionDate)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                }
                
            }

            Text(pointsString)
                .accessibilityIdentifier(accessibilityID + "_" +  AppAccessibilty.Transaction.points)
                .font(.transactionPoints)
                .foregroundColor(Int(points) < 0 ? Color.theme.negativePoints : Color.theme.points)
            
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
            TransactionCardView(accessibilityID: "id", transaction: dev.transactions[0])
            TransactionCardView(accessibilityID: "id", transaction: dev.transactions[1])
        }
        
    }
}
