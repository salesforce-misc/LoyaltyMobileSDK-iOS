//
//  Badge.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 27/03/24.
//

import Foundation

struct Badge {
	let id: String
	let name: String
	let description: String
	let type: BadgeType
	let imageUrl: String?
	let daysToExpire: Int?
	let endDateString: String?
	
	init(
		id: String,
		name: String,
		description: String,
		type: BadgeType,
		endDate: Date?,
		currentDate: Date,
		imageUrl: String?
	) {
		self.id = id
		self.name = name
		self.description = description
		self.type = type
		self.endDateString = endDate?.toString(withFormat: "yyyy-MM-dd")
		self.daysToExpire = endDate?.getDays(from: currentDate)
		self.imageUrl = imageUrl
	}
}
