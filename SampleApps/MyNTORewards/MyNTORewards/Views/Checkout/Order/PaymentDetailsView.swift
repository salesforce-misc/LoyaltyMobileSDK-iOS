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
            VStack(alignment: .leading) {
                OrderVoucherView().cornerRadius(16, corners: .allCorners)
            }
            .padding(16)
            
            AmountPayableView()
                .padding(16)
            PaymentCardView()
                .cornerRadius(16, corners: .allCorners)
                .padding(16)
            
            PaymentCardView()
                .cornerRadius(16, corners: .allCorners)
                .padding(16)
            
            Button{} label: {
                Text("Confirm Order")
                    .font(.boldButtonText)
            }
                .buttonStyle(DarkFlexibleButton())
                .padding()
        }
        .background(Color(hex: "#F1F3FB"))
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsView()
    }
}
