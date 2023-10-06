//
//  AmountPayableView.swift
//  MyNTORewards
//
//  Created by Anandhakrishnan Kanagaraj on 15/03/23.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct AmountPayableView: View {
	@EnvironmentObject var productVM: ProductViewModel
	@EnvironmentObject var profileVM: ProfileViewModel
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                CheckBoxView(checked: .constant(false))
                Text("Use my points")
                    .font(.useMyPointsText)
                Spacer()
				Text("Available Points: \(Int(profileVM.profile?.getCurrencyPoints(currencyName: AppSettings.Defaults.rewardCurrencyName) ?? 0))")
                    .font(.useMyPointsText)
            }
            HStack {
                Text("Pay:")
                    .font(.voucherHederText)
                Spacer()
				Text(" $\(productVM.getTotalAmount())")
					.font(.totalAmountText)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16, corners: .allCorners)
        }
        .foregroundColor(Color.theme.lightText)
    }
}

struct AmountPayableView_Previews: PreviewProvider {
    static var previews: some View {
        AmountPayableView()
            .environmentObject(dev.profileVM)
            .environmentObject(dev.productVM)
    }
}
