//
//  OrderVoucherView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct OrderVoucherView: View {
	@State var selectedValue: VoucherTitle = VoucherTitle(id: "0", title: "Select a Voucher")
	
    var body: some View {
        VStack(alignment: .leading) {
            Text("Vouchers")
                .font(.voucherHederText)
                .foregroundColor(Color.theme.lightText)
			VoucherPickerView(selectedValue: $selectedValue)
                .frame(height: 44)
                .padding([.top, .bottom])
        }
        .padding()
        .background(Color.white)
    }
}

struct OrderVoucherView_Previews: PreviewProvider {
    static var previews: some View {
        OrderVoucherView()
    }
}
