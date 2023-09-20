//
//  CameraView.swift
//  MyNTORewards
//
//  Created by Leon Qi on 7/18/23.
//

import AVFoundation
import Photos
import SwiftUI

struct CameraView: View {
    @StateObject var camera = CameraController()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showPhotoPicker = false
    @State private var latestPhoto: UIImage = UIImage()
    @State private var flashMode: AVCaptureDevice.FlashMode = .off
    @Binding var showCapturedImage: Bool
    @Binding var capturedImage: UIImage?

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .onAppear {
                    camera.prepare { error in
                        if let error = error {
                            print(error)
                        }
                        try? camera.displayPreview(on: camera.previewView)
                    }
                }
                .onTapGesture(perform: { location in
                    camera.setFocusPointToTapLocation(location)
                })
                .background(Color.black)

            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
						print("camera close button tapped")
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .padding(10)
                            .foregroundColor(.white)
                    }
					.accessibilityIdentifier(AppAccessibilty.Receipts.closeCameraButton)
                    .buttonStyle(CircularButtonStyle())
                    .padding(.leading, 20)

                    Spacer()

                    Button(action: {
                        // Rotate between off, on and auto
                        flashMode = AVCaptureDevice.FlashMode(rawValue: (flashMode.rawValue + 1) % 3) ?? .off
                        camera.flashMode = flashMode
                    }) {
                        Image(systemName: flashMode == .off ? "bolt.slash.fill" : (flashMode == .on ? "bolt.fill" : "bolt.badge.a.fill"))
                            .font(.system(size: 25))
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CircularButtonStyle())
                    .padding(.trailing, 20)
                }
                .padding(.top, 50)

                Spacer()

                HStack {
                    Text("Click or Upload the Receipt")
                        .foregroundColor(Color.white)
                }
                HStack {
                    Button(action: {
                        fetchLatestPhoto()
                        showPhotoPicker = true
                    }) {
                        Image(uiImage: latestPhoto)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10, corners: .allCorners)
                            .padding(.all, 15)
                    }
					.accessibilityIdentifier(AppAccessibilty.Receipts.chooseFromPhotos)
                    .padding(.leading, 20)
                    .sheet(isPresented: $showPhotoPicker) {
                        ImagePickerView(image: self.$capturedImage, showCapturedImage: self.$showCapturedImage, sourceType: .photoLibrary)
                    }
                    
                    Spacer()

                    Button(action: {
                        camera.captureImage(flashMode: camera.flashMode) { image, error in
                            guard let image = image else {
                                print(error ?? "Image capture error")
                                return
                            }
                            DispatchQueue.main.async {
                                self.capturedImage = image
                                self.showCapturedImage = true
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .inset(by: 8)
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 75, height: 75)
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 50))
                                .padding(10)
                                .foregroundColor(.white)
                        }
                        
                    }
					.accessibilityIdentifier(AppAccessibilty.Receipts.cameraShutterButton)

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Hidden button")
                    }
                    .opacity(0)
                    .disabled(true)

                }
                .padding(.bottom, 50)
            }
            .onAppear {
                fetchLatestPhoto()
            }
            
        }
    }
    
    func fetchLatestPhoto() {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // swiftlint:disable empty_count
        if fetchResult.count > 0 {
            if let lastAsset: PHAsset = fetchResult.firstObject {
                PHImageManager.default().requestImage(for: lastAsset,
                                                      targetSize: CGSize(width: 50, height: 50),
                                                      contentMode: .default,
                                                      options: requestOptions,
                                                      resultHandler: { image, _ in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.latestPhoto = image
                        }
                    }
                })
            }
        }
        // swiftlint:enable empty_count
    }

}

struct CameraPreview: UIViewRepresentable {
    let camera: CameraController

    func makeUIView(context: Context) -> some UIView {
        return camera.previewView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let captureSession = AVCaptureSession()
    var previewView = UIView()
    private let photoOutput = AVCapturePhotoOutput()
    private var captureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var flashMode: AVCaptureDevice.FlashMode = .off
    var focusSquare: CAShapeLayer?
    var previewLayer: AVCaptureVideoPreviewLayer?

    func prepare(completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                    throw CameraControllerError.noCamerasAvailable
                }
                
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)

                if self.captureSession.canAddInput(captureDeviceInput) {
                    self.captureSession.addInput(captureDeviceInput)
                }

                if self.captureSession.canAddOutput(self.photoOutput) {
                    self.captureSession.addOutput(self.photoOutput)
                }

                self.captureSession.startRunning()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func captureImage(flashMode: AVCaptureDevice.FlashMode, completion: @escaping (UIImage?, Error?) -> Void) {
        let settings = AVCapturePhotoSettings()
        if photoOutput.supportedFlashModes.contains(flashMode) { // check if the selected mode is supported
            settings.flashMode = flashMode
        } else {
            settings.flashMode = .off // fall back to .off if the selected mode is not supported
        }
        photoOutput.capturePhoto(with: settings, delegate: self)
        captureCompletionBlock = completion
    }

    func displayPreview(on view: UIView) throws {
        guard captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }

        previewView = view
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewView.layer.addSublayer(previewLayer!)
        //previewView.layer.sublayers?.first?.frame = previewView.frame
        previewView.layer.sublayers?.first?.frame = previewView.bounds // Change frame to bounds to match the actual size of the preview view
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            captureCompletionBlock?(nil, error)
            return
        }

        guard let imageData = photo.fileDataRepresentation() else {
            captureCompletionBlock?(nil, CameraControllerError.imageProcessingFailed)
            return
        }

        let uiImage = UIImage(data: imageData)
        captureCompletionBlock?(uiImage, nil)
    }
    
    func setFocusPointToTapLocation(_ location: CGPoint) {
        // Create a square for the focus area
        let square = CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100)
        focusSquare?.removeFromSuperlayer()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: square).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 2
        
        previewView.layer.addSublayer(shapeLayer)
        focusSquare = shapeLayer
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }

        do {
            try device.lockForConfiguration()

            // Convert tap location into camera coordinates and set as focus point
            let cameraPoint = previewLayer?.captureDevicePointConverted(fromLayerPoint: location)
            
            if let cameraPoint = cameraPoint {
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
                    device.focusPointOfInterest = cameraPoint
                    device.focusMode = .autoFocus
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.autoExpose) {
                    device.exposurePointOfInterest = cameraPoint
                    device.exposureMode = .autoExpose
                }
            }

            device.unlockForConfiguration()
        } catch {
            print("Failed to focus and expose with error: \(error)")
        }
    }

    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
        case imageProcessingFailed
    }
}
