//
//  OrderVoucherView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct OrderVoucherView: View {
    let checkoutVouchersCode = ["Trendy wear 25 off", "Trendy wear 50 off", "Trendy wear 15 off", "Trendy wear 75 off", "Trendy wear 100 off"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Vouchers")
                .font(.voucherHederText)
                .foregroundColor(Color(hex: "#181818"))
            VoucherPickerView(pickerViewInputValues: .constant(checkoutVouchersCode), selectedValue: .constant(checkoutVouchersCode[0]))
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
