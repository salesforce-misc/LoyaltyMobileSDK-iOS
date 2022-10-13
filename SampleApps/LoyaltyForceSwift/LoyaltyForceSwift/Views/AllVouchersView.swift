//
//  AllVouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct AllVouchersView: View {

    @Environment(\.dismiss) private var dismiss
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
                .padding(.top, 150)
                
                if showVoucherDetailView {
                    VoucherDetailView()
                        .transition(.move(edge: .bottom))
                }
                
            }
            
            VStack(spacing: 0) {
//                HStack {
//                    Button {
//                    } label: {
//                        Image("ic-backarrow")
//                    }
//                    .padding(.leading, 15)
//
//                    Spacer()
//                    Image("ic-search")
//                        .padding(.trailing, 15)
//                }
//                .frame(height: 44)
//                .frame(maxWidth: .infinity)
//                .background(Color.white)
//
//                HStack {
//                    Text("Vouchers")
//                        .font(.nameText)
//                        .padding(.leading, 15)
//                    Spacer()
//                }
//                .frame(height: 44)
//                .frame(maxWidth: .infinity)
//                .background(Color.white)
                
                TopTabBar(barItems: barItems, tabIndex: $tabSelected)
                Spacer()
            }
            
        }
        .navigationTitle("Vouchers")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("ic-backarrow")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //
                } label: {
                    Image("ic-search")
                }
            }
        }

    }

}

struct AllVouchersView_Previews: PreviewProvider {
    static var previews: some View {
        AllVouchersView()
    }
}
