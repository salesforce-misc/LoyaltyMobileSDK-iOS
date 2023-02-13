//
//  VoucherModel.swift
//  
//
//  Created by Vasanthkumar Velusamy on 13/02/23.
//

public struct VouchersResponse: Codable {
	public let vouchers: [VoucherModel]?
}

// MARK: - Voucher Model
public struct VoucherModel: Codable, Identifiable {
	public let id: String?
	public let voucherDefinition: String?
	public let description: String?
	public let type: String?
	public let faceValue: String?
	public let discountPercent: String?
	public let code: String?
	public let expirationDate: String?
	public let voucherImageUrl: String?
	public let status: String?
	public let partnerAccount: String?
	public let product: String?
	public let productCategory: String?
	public let voucherNumber: String?
	public let effectiveDate: String?
	public let redeemedValue: String?
	public let remainingValue: String?
	public let currencyIsoCode: String?
	public let isVoucherDefinitionActive: Bool?
	public let isVoucherPartiallyRedeemable: Bool?
	public let productId: String?
	public let productCategoryId: String?
	public let useDate: String?
	public let promotionName: String?
	public let promotionId: String?
}
