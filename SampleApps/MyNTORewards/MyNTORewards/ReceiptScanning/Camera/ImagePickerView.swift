//
//  ImagePicker.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/12/23.
//

import SwiftUI
import PhotosUI
import LoyaltyMobileSDK

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cameraVM: CameraViewModel
    @Binding var imageData: Data?
    @Binding var showCapturedImage: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.hasItemConformingToTypeIdentifier(UTType.heic.identifier) {
                provider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let error = error {
                        Logger.error("Photos picker error: \(error)")
                    }
    
                    if let uiImage = object as? UIImage {
                        Logger.debug("Data size: \(uiImage.jpegData(compressionQuality: 0.7)?.count ?? 0) | The max size is \(5 * 1024 * 1024)")
    
                        DispatchQueue.main.async {
                            if let jpegData = uiImage.jpegData(compressionQuality: 0.7) {
                                self.parent.imageData = jpegData
                                self.parent.showCapturedImage = true
                            }
                        }
                    }
                }

            } else if provider.hasItemConformingToTypeIdentifier(UTType.jpeg.identifier) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.jpeg.identifier) { data, error in
                    if let error = error {
                        Logger.error("Photos picker error: \(error)")
                    }
                    
                    Logger.debug("JEPG Data size: \(data?.count ?? 0) | The max size is \(5 * 1024 * 1024)")
                    if let data = data {
                        DispatchQueue.main.async {
                            self.parent.imageData = data
                            self.parent.showCapturedImage = true
                        }
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.png.identifier) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.png.identifier) { data, error in
                    if let error = error {
                        Logger.error("Photos picker error: \(error)")
                    }
                    
                    Logger.debug("PNG Data size: \(data?.count ?? 0) | The max size is \(5 * 1024 * 1024)")
                    if let data = data {
                        DispatchQueue.main.async {
                            self.parent.imageData = data
                            self.parent.showCapturedImage = true
                        }
                    }
                }

            } else {
                Logger.error("File type is not supported. Files can only be in HEIC, JPEG and PNG format.")
                self.parent.cameraVM.showCamera = false
                self.parent.cameraVM.showErrorView = ErrorViewData(showError: true,
                                                                   errorType: .typeUnsupported,
                                                                   errorMessage: StringConstants.Receipts.formatUnsupported)
            }
        }
    }
}
