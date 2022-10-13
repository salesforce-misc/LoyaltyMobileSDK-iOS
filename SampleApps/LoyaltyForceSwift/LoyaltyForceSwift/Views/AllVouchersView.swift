//
//  AllVouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct AllVouchersView: View {

    @State var showVoucherDetailView = false
    @State var tabSelected: Int = 0
    let barItems = ["Available", "Redeemed", "Expired"]
    
    var body: some View {
        ZStack {
            Color.theme.background
                
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 15) {
                    HStack {
                        Button {
                            showVoucherDetailView.toggle()
                        } label: {
                            VoucherCardView()
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showVoucherDetailView) {
                            VoucherDetailView()
                        }

                        
                        VoucherCardView()
                    }
                    HStack {
                        VoucherCardView()
                        VoucherCardView()
                    }
                    HStack {
                        VoucherCardView()
                        VoucherCardView()
                    }
                    HStack {
                        VoucherCardView()
                        VoucherCardView()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                
                if showVoucherDetailView {
                    VoucherDetailView()
                        .transition(.move(edge: .bottom))
                }
                
            }
            
        }
        .loytaltyNavigationTitle("Vouchers")
        .loyaltyNavBarTabBar(TopTabBar(barItems: barItems, tabIndex: $tabSelected))

    }

}

struct AllVouchersView_Previews: PreviewProvider {
    static var previews: some View {
        AllVouchersView()
    }
}
