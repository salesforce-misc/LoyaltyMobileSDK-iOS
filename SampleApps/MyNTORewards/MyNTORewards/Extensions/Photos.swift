//
//  Photos.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 05/10/23.
//

import Photos
import Foundation

public extension PHAsset {
	var assetSize: Float {
		let asset = PHAssetResource.assetResources(for: self)
		let imageSizeByte = asset.first?.value(forKey: "fileSize") as? Float ?? 0.0
		let imageSizeMB = imageSizeByte / (1024.0 * 1024.0)
		let addAverageDeficit = imageSizeMB / 10
		return (imageSizeMB + (imageSizeMB + addAverageDeficit)) / 2
	}
}
