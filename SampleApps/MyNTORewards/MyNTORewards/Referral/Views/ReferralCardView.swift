//
//  ReferralCardView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 15/02/24.
//

import SwiftUI

struct ReferralCardView: View {
    let status: ReferralStatus
    let email: String
    let referralDate: Date
    
    var body: some View {
        HStack(alignment: .center) {
            Assets.getReferralStatusIcon(status: status)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.leading, 8)
            VStack(alignment: .leading, spacing: 6) {
                Text("**\(email)**")
                    .font(.referralCardText)
                HStack {
                    Text(displayDate(referralDate: referralDate))
                        .font(.referralCardText)
                        .foregroundColor(Color.theme.textInactive)
                    Spacer()
                    Text("**\(status.rawValue)**")
                        .font(.referralStatus)
                        .foregroundColor(status == .purchaseCompleted ? Color.theme.purchaseCompleted : Color.theme.superLightText)
                }
                .padding(.trailing, 10)
            }.padding(.vertical, 14)
        }
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
    
    func displayDate(referralDate: Date) -> String {
        let calendar = Calendar.current
        let startOfCurrentDate = calendar.startOfDay(for: Date())
        let startOfInputDate = calendar.startOfDay(for: referralDate)
        
        let components = calendar.dateComponents([.day], from: startOfInputDate, to: startOfCurrentDate)
        let days: Int = components.day ?? 0
        return days == 0 ? "Today" : days == 1 ? "One Day Ago" : days <= 30 ? "\(days) Days Ago" : referralDate.toString()
        
    }
}
