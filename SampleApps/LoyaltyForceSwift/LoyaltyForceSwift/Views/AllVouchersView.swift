//
//  AllVouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct AllVouchersView: View {

    @Binding var showAllVouchersView: Bool
    @State var tabSelected: Int = 0
    let barItems = ["Available", "Redeemed", "Expired"]
    
    var body: some View {
        ZStack {
            Color.theme.background
//                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                    .onEnded({ value in
//                        if value.translation.width > 0 {
//                            withAnimation {
//                                showAllVouchersView.toggle()
//                            }
//                        }
//                    })
//                )
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 15) {
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
                    HStack {
                        VoucherCardView()
                        VoucherCardView()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 150)
                
            }
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation {
                            showAllVouchersView.toggle()
                        }
                    } label: {
                        Image("ic-backarrow")
                    }
                    .padding(.leading, 15)

                    Spacer()
                    Image("ic-search")
                        .padding(.trailing, 15)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                HStack {
                    Text("Vouchers")
                        .font(.nameText)
                        .padding(.leading, 15)
                    Spacer()
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                TopTabBar(barItems: barItems, tabIndex: $tabSelected)
                Spacer()
            }
            
        }
        .zIndex(2.0)

    }

}

struct AllVouchersView_Previews: PreviewProvider {
    static var previews: some View {
        AllVouchersView(showAllVouchersView: .constant(false))
    }
}
