//
//  VouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VouchersView: View {
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Vouchers")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()                
                NavigationLink(destination: {
                    AllVouchersView()
                }, label: {
                    Text("View All")
                        .foregroundColor(Color.theme.accent)
                        .font(.offerViewAll)
                })
            }
            .padding()
            
            HStack {
                Spacer()
                VoucherCardView()
                Spacer()
                VoucherCardView()
                Spacer()
            }
            
        }
        .frame(height: 320)
    }
}

struct VouchersView_Previews: PreviewProvider {
    static var previews: some View {
        VouchersView()
    }
}
