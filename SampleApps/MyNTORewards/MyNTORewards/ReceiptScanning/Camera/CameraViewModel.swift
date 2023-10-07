//
//  CameraModel.swift
//  MyNTORewards
//
//  Created by Vasanthkumar Velusamy on 03/08/23.
//

import SwiftUI

enum FileUploadError {
    case none
    case sizeTooBig
    case typeUnsupported
}

struct ErrorViewData {
    var showError: Bool = false
    var errorType: FileUploadError = .none
    var errorMessage: String = ""
}

class CameraViewModel: ObservableObject {
	@Published var showCamera = false
    @Published var showErrorView: ErrorViewData = ErrorViewData()
}
