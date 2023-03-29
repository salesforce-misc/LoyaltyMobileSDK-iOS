/*
 * Copyright (c) 2023, Salesforce, Inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

public struct VouchersResponse: Codable {
	public let vouchers: [VoucherModel]?
}

// MARK: - Voucher Model
public struct VoucherModel: Codable, Identifiable {
	public let id, voucherDefinition, voucherCode, voucherNumber: String
	public let description: String?
	public let type: String?
	public let discountPercent: Int?
	public let expirationDate, effectiveDate: String
	public let useDate: String?
	public let voucherImageUrl: String?
	public let attributesUrl: String?
	public let status: String?
	public let partnerAccount: String?
	public let faceValue, redeemedValue, remainingValue: Double?
	public let currencyIsoCode: String?
	public let isVoucherDefinitionActive, isVoucherPartiallyRedeemable: Bool?
	public let product, productId, productCategoryId, productCategory: String?
	public let promotionName, promotionId: String?
	
	public init(id: String, voucherDefinition: String, voucherCode: String, voucherImageUrl: String?, voucherNumber: String, description: String?, type: String?, discountPercent: Int?, expirationDate: String, effectiveDate: String, useDate: String?, attributesUrl: String?, status: String?, partnerAccount: String?, faceValue: Double?, redeemedValue: Double?, remainingValue: Double?, currencyIsoCode: String?, isVoucherDefinitionActive: Bool?, isVoucherPartiallyRedeemable: Bool?, product: String?, productId: String?, productCategoryId: String?, productCategory: String?, promotionName: String?, promotionId: String?) {
		self.id = id
		self.voucherDefinition = voucherDefinition
		self.voucherCode = voucherCode
		self.voucherImageUrl = voucherImageUrl
		self.voucherNumber = voucherNumber
		self.description = description
		self.type = type
		self.discountPercent = discountPercent
		self.expirationDate = expirationDate
		self.effectiveDate = effectiveDate
		self.useDate = useDate
		self.attributesUrl = attributesUrl
		self.status = status
		self.partnerAccount = partnerAccount
		self.faceValue = faceValue
		self.redeemedValue = redeemedValue
		self.remainingValue = remainingValue
		self.currencyIsoCode = currencyIsoCode
		self.isVoucherDefinitionActive = isVoucherDefinitionActive
		self.isVoucherPartiallyRedeemable = isVoucherPartiallyRedeemable
		self.product = product
		self.productId = productId
		self.productCategoryId = productCategoryId
		self.productCategory = productCategory
		self.promotionName = promotionName
		self.promotionId = promotionId
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(String.self, forKey: .id)
		
		self.voucherDefinition = try container.decode(String.self, forKey: .voucherDefinition)
		self.voucherCode = try container.decode(String.self, forKey: .voucherCode)
		self.voucherImageUrl = try container.decodeIfPresent(String.self, forKey: .voucherImageUrl)
		self.voucherNumber = try container.decode(String.self, forKey: .voucherNumber)
		self.description = try container.decodeIfPresent(String.self, forKey: .description)
		self.type = try container.decodeIfPresent(String.self, forKey: .type)
		self.discountPercent = try container.decodeIfPresent(Int.self, forKey: .discountPercent)
		self.expirationDate = try container.decode(String.self, forKey: .expirationDate)
		self.effectiveDate = try container.decode(String.self, forKey: .effectiveDate)
		self.useDate = try container.decodeIfPresent(String.self, forKey: .useDate)
		self.attributesUrl = try container.decodeIfPresent(String.self, forKey: .attributesUrl)
		self.status = try container.decodeIfPresent(String.self, forKey: .status)
		self.partnerAccount = try container.decodeIfPresent(String.self, forKey: .partnerAccount)
		self.faceValue = try container.decodeIfPresent(Double.self, forKey: .faceValue)
		self.redeemedValue = try container.decodeIfPresent(Double.self, forKey: .redeemedValue)
		self.remainingValue = try container.decodeIfPresent(Double.self, forKey: .remainingValue)
		self.currencyIsoCode = try container.decodeIfPresent(String.self, forKey: .currencyIsoCode)
		self.isVoucherDefinitionActive = try container.decodeIfPresent(Bool.self, forKey: .isVoucherDefinitionActive)
		self.isVoucherPartiallyRedeemable = try container.decodeIfPresent(Bool.self, forKey: .isVoucherPartiallyRedeemable)
		self.product = try container.decodeIfPresent(String.self, forKey: .product)
		self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
		self.productCategoryId = try container.decodeIfPresent(String.self, forKey: .productCategoryId)
		self.productCategory = try container.decodeIfPresent(String.self, forKey: .productCategory)
		self.promotionName = try container.decodeIfPresent(String.self, forKey: .promotionName)
		self.promotionId = try container.decodeIfPresent(String.self, forKey: .promotionId)
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "voucherId"
		case voucherDefinition, voucherCode, voucherImageUrl, voucherNumber
		case description
		case type
		case discountPercent
		case expirationDate, effectiveDate, useDate
		case attributesUrl
		case status
		case partnerAccount
		case faceValue, redeemedValue, remainingValue
		case currencyIsoCode
		case isVoucherDefinitionActive, isVoucherPartiallyRedeemable
		case product, productId, productCategoryId, productCategory
		case promotionName, promotionId
	}
}
