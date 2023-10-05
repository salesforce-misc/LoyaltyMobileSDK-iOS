//
//  OrderVoucherView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct OrderVoucherView: View {
	@EnvironmentObject var profileVM: ProfileViewModel
	@EnvironmentObject var vouchersVM: VoucherViewModel
	@State var selectedValue: VoucherTitle = VoucherTitle(id: "0", title: "Select a Voucher")
	
    var body: some View {
        VStack(alignment: .leading) {
            Text("Vouchers")
                .font(.voucherHederText)
                .foregroundColor(Color.theme.lightText)
			VoucherPickerView(selectedValue: $selectedValue, pickerViewInputValues: vouchersVM.availableVouchersTitles)
                .frame(height: 44)
                .padding([.top, .bottom])
        }
        .padding()
        .background(Color.white)
		.task {
			do {
				let membershipNumber = profileVM.profile?.membershipNumber ?? ""
				try await vouchersVM.getTitlesOfAvailableVouchers(membershipNumber: membershipNumber)
			} catch {
				Logger.error("Error fetch vouchers titles")
			}
		}
    }
}

struct OrderVoucherView_Previews: PreviewProvider {
    static var previews: some View {
        OrderVoucherView()
            .environmentObject(dev.profileVM)
            .environmentObject(dev.voucherVM)
    }
}
