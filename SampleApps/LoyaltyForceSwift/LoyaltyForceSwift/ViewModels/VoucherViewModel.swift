//
//  VoucherViewModel.swift
//  LoyaltyForceSwift
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation

class VoucherViewModel: ObservableObject {

    @Published var vouchers: [VoucherModel] = []
    
    func getVouchers(membershipName: String, reload: Bool = false) async throws {
        
//        do {
//
//            if reload {
//                // network soql
//            } else {
//                if let cached = LocalFileManager.instance.getData(type: VoucherModel.self, id: membershipName, folderName: "Vouchers") {
//                    vouchers = cached
//                } else {
//
//                }
//            }
//
//            let results = try await LoyaltyAPIManager.shared.getVoucherRecords(membershipNumber: membershipName)
//            for result in results {
//
//            }
//
//        } catch {
//            throw error
//        }
    }
}
