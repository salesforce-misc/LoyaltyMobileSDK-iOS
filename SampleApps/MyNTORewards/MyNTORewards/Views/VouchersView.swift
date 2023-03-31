//
//  VouchersView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct VouchersView: View {
    
    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    
    var body: some View {
        
        ViewAllView(title: "My Vouchers") {
            AllVouchersView()
        } content: {
            HStack(spacing: 20) {
                if voucherVM.vouchers.isEmpty {
                    EmptyStateView(title: "You have no Vouchers Available")
                }
                ForEach(voucherVM.vouchers) { voucher in
                    VoucherCardView(voucher: voucher)
                }
                
            }
            .task {
                do {
                    try await voucherVM.loadVouchers(membershipNumber: rootVM.member?.membershipNumber ?? "")
                } catch {
                    print("Load Vouchers Error: \(error)")
                }
            }
        }
        .frame(height: 320)
        
    }
}

struct VouchersView_Previews: PreviewProvider {
    static var previews: some View {
        VouchersView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.voucherVM)
    }
}
