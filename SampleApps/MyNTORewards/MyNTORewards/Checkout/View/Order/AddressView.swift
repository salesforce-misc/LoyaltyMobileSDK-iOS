//
//  AddressView.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 10/03/23.
//

import SwiftUI
import LoyaltyMobileSDK

struct AddressView: View {
    @EnvironmentObject private var rootVM: AppRootViewModel
	@EnvironmentObject var orderDetailsViewModel: OrderDetailsViewModel
	@Binding var selectedIndex: Int

    var body: some View {
		VStack(spacing: 0) {
			HStack {
				VStack(alignment: .leading, spacing: 6) {
					Text("Nancy Tran")
						.font(.mediumHeaderText)
					Group {
						Text("4897 Davis Lane")
						Text("Centennial")
						Text("Colorado")
						Text("Zip code 80112")
					}
					.font(.lightBodyText)
				}
				Spacer()
			}
			.padding()
			HStack {
				Button {} label: {
					Text("Edit Address")
						.font(.selectionTitleText)
				}
				Spacer()
				Button {} label: {
					Text("Delete Address")
						.font(.selectionTitleText)
				}
			}
			.padding(.horizontal)
			.padding(.top)
			.padding(.bottom)
		}
		.background(Color.white)
        .task {
            do {
                try await orderDetailsViewModel.getShippingAddress(membershipNumber: rootVM.member?.loyaltyProgramMemberId ?? "")
            } catch {
                Logger.error("Load Vouchers Error: \(error)")
            }
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
		AddressView(selectedIndex: .constant(0))
			.environmentObject(dev.orderDetailsVM)
    }
}
