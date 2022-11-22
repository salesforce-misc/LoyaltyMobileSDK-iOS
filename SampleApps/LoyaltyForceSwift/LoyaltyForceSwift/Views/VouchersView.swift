//
//  VouchersView.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VouchersView: View {
    
    @State var showVoucherDetailView = false
    
    var body: some View {
        
        ViewAllView(title: "My Vouchers") {
            AllVouchersView()
        } content: {
            HStack {
                Spacer()
                VoucherCardView()
                    .onTapGesture {
                        showVoucherDetailView.toggle()
                    }
                    .sheet(isPresented: $showVoucherDetailView) {
                        VoucherDetailView()
                    }
                Spacer()
                VoucherCardView2()
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
