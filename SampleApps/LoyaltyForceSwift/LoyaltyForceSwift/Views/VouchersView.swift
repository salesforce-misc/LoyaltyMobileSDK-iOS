//
//  VouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VouchersView: View {
    
    @Binding var showAllVouchersView: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Vouchers")
                    .font(.offerTitle)
                    .foregroundColor(.black)
                Spacer()
                Text("View All")
                    .foregroundColor(Color.theme.accent)
                    .font(.offerViewAll)
                    .onTapGesture {
                        //print("clicked")
                        withAnimation {
                            showAllVouchersView.toggle()
                        }
                        
                    }
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
        .frame(height: 400)
    }
}

struct VouchersView_Previews: PreviewProvider {
    static var previews: some View {
        VouchersView(showAllVouchersView: .constant(false))
    }
}
