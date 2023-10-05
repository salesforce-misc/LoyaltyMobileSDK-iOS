//
//  ImagePicker.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/12/23.
//

import SwiftUI
import Photos

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
	@Binding var phAsset: PHAsset?
    @Binding var showCapturedImage: Bool
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.showCapturedImage = true
            }
			
			if let phAsset = info[.phAsset] as? PHAsset {
				parent.phAsset = phAsset
				parent.showCapturedImage = true
			}

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
