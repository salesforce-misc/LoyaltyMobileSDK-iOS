//
//  AllVouchersView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 10/10/22.
//

import SwiftUI

struct AllVouchersView: View {

    @EnvironmentObject private var rootVM: AppRootViewModel
    @EnvironmentObject private var voucherVM: VoucherViewModel
    @State var tabSelected: Int = 0
    let barItems = ["Available", "Redeemed", "Expired"]
    let columns = [
        GridItem(.fixed(180)),
        GridItem(.fixed(180))
    ]
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            TabView(selection: $tabSelected) {
                availableView
                    .tag(0)
                redeemedView
                    .tag(1)
                expiredView
                    .tag(2) 
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

        }
        .loytaltyNavigationTitle("Vouchers")
        .loyaltyNavBarTabBar(TopTabBar(barItems: barItems, tabIndex: $tabSelected))
        .task {
            do {
                try await voucherVM.loadAvailableVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Load Available Vouchers Error: \(error)")
            }
        }
        .task {
            do {
                try await voucherVM.loadRedeemedVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Load Redeemed Vouchers Error: \(error)")
            }
        }
        .task {
            do {
                try await voucherVM.loadExpiredVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "")
            } catch {
                print("Load Expired Vouchers Error: \(error)")
            }
        }

    }
    
    var availableView: some View {
        
        ScrollView {
            if voucherVM.availableVochers.isEmpty {
                EmptyStateView(title: "You have no Available Vouchers")
            }
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(voucherVM.availableVochers) { voucher in
                    VoucherCardView(voucher: voucher)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
        }
        .refreshable {
            print("Reloading available vouchers...")
            do {
                try await voucherVM.loadAvailableVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "", reload: true)
            } catch {
                print("Reload Available Vouchers Error: \(error)")
            }
        }
    }
    
    var redeemedView: some View {
        
        ScrollView {
            if voucherVM.availableVochers.isEmpty {
                EmptyStateView(title: "You have no Redeemed Vouchers")
            }
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(voucherVM.redeemedVochers) { voucher in
                    VoucherCardView(voucher: voucher)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
        }
        .refreshable {
            print("Reloading redeemed vouchers...")
            do {
                try await voucherVM.loadRedeemedVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "", reload: true)
            } catch {
                print("Reload Redeemed Vouchers Error: \(error)")
            }
        }
    }
    
    var expiredView: some View {
        
        ScrollView {
            if voucherVM.availableVochers.isEmpty {
                EmptyStateView(title: "You have no Expired Vouchers")
            }
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(voucherVM.expiredVochers) { voucher in
                    VoucherCardView(voucher: voucher)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
        }
        .refreshable {
            print("Reloading expired vouchers...")
            do {
                try await voucherVM.loadExpiredVouchers(membershipNumber: rootVM.member?.enrollmentDetails.membershipNumber ?? "", reload: true)
            } catch {
                print("Reload Expired Vouchers Error: \(error)")
            }
        }
    }

}

struct AllVouchersView_Previews: PreviewProvider {
    static var previews: some View {
        AllVouchersView()
            .environmentObject(dev.rootVM)
            .environmentObject(dev.voucherVM)
    }
}
