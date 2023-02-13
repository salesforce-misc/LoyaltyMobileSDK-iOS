//
//  VoucherModel.swift
//  MyNTORewards
//
//  Created by Leon Qi on 11/21/22.
//

import Foundation

public struct VoucherModel: Codable, Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let type: String
    public let faceValue: String?
    public let discountPercent: String?
    public let code: String?
    public let expirationDate: String
    public let image: String?
    public let status: String
	public let partnerAccount: String?
	public let product: String?
	public let productCategory: String?
	public let voucherNumber: String?
	public let effectiveDate: String?
	public let redeemedValue: String?
	public let remainingValue: String?
	public let currencyIsoCode: String?
	public let isVoucherDefinitionActive: Bool
	public let isVoucherPartiallyRedeemable: Bool
	public let productId: String?
	public let productCategoryId: String?
	public let useDate: String?
	public let promotionName: String?
	public let promotionId: String?
}
