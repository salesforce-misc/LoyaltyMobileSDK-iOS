//
//  PaymentDetailsView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct PaymentDetailsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                OrderVoucherView().cornerRadius(16, corners: .allCorners)
                
                AmountPayableView()
                PaymentCardView()
                    .cornerRadius(16, corners: .allCorners)
                
                Button {} label: {
                    Text("Confirm Order")
                        .font(.boldButtonText)
                }
                .buttonStyle(DarkFlexibleButton())
                .padding()
            }.padding()
        }
        .background(Color(hex: "#F1F3FB"))
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsView()
    }
}
