//
//  PhotoViewController.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 05/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit
import Photos

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • LOCAL DEFINES / ENUMS

//MARK: - • CLASS

class PhotoViewController: ModelViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - • PUBLIC PROPERTIES

    @IBOutlet weak var imvPhoto: UIImageView!
    @IBOutlet weak var btnPhoto: UIButton!
    
    //MARK: - • PRIVATE PROPERTIES
    
    
    //MARK: - • INITIALISERS
    
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    //ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //Super Methods
    
    override func setupLayout() {
        super.defaultSetup("Photo")
        //
        //Custom setup here...
    }
    
    override func loadContent() {
        //Insert code here...
        contentLoaded = true
    }
    
    override func systemKeyboardShow(height: CGFloat, animationDuration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        print("\(#function)")
    }
    
    override func systemKeyboardHide() {
        print("\(#function)")
    }
    
    //MARK: - • CONTROLLER LIFECYCLE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    //UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            var edited = photo.imageOrientedToUP()
            edited = edited.resizedImageToFrameSize(CGSize.init(width: 500.0, height: 500.0))
            
            imvPhoto.image = edited
        }
        
        picker.dismiss(animated: true) {
            print("y")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //ViewControllerProtocol
    
    func showLoading() {
        self.showActivityIndicator(inStatusBar: true)
    }
    
    func hideLoading() {
        self.hideActivityIndicator(inStatusBar: true)
    }
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionPhoto(sender:Any?) -> Void {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            self.openCamera()
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    self.openCamera()
                }
            })
            
        case .denied:
            DispatchQueue.main.async {
                let message = "O aplicativo não possui permissão para acessar a câmera. Por favor, modifique as configurações de privacidade para continuar."
                let alertController = UIAlertController(title: "Atenção!", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Opções", style: .`default`, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            
        case .restricted:
            DispatchQueue.main.async {
                let message = "Nenhum dispositivo de câmera está disponível para uso no momento."
                let alertController = UIAlertController(title: "Atenção!", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func openCamera() -> Void {
        
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .camera
        photoPicker.cameraDevice = .front
        photoPicker.showsCameraControls = true
        //
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidCaptureItem"), object:nil, queue:nil, using: { note in
            photoPicker.cameraOverlayView?.alpha = 0.0
        })
        //
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "_UIImagePickerControllerUserDidRejectItem"), object:nil, queue:nil, using: { note in
            photoPicker.cameraOverlayView?.alpha = 1.0
        })
        //
        self.present(photoPicker, animated: true) {
            photoPicker.cameraOverlayView = self.createCameraOverlayView() //view or imageView
        }
    }
    
    private func createCameraOverlayView() -> UIView {
        
        //NOTE: 44.0 e 140.0 são as medidas dos controles da câmera do sistema
        let overlayFrame = CGRect.init(x: 0.0, y: 44.0 + self.view.safeAreaInsets.top, width: self.view.frame.size.width, height: UIScreen.main.bounds.size.height - (140.0 + 44.0 + self.view.safeAreaInsets.bottom))
        let overlayView = UIView.init(frame: overlayFrame)
        
        //background:
        let extHeight = overlayFrame.size.height
        let extWidth = overlayFrame.size.width
        let intHeight = extHeight * 0.7
        let intWidth = extWidth * 0.7
        let paddingX = (extWidth-intWidth) / 2.0
        let paddingY = (extHeight-intHeight) / 2.0

        let externalPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0.0, y: 0.0, width: extWidth, height: extHeight), cornerRadius: 0.0)
        let internalPath = UIBezierPath.init(roundedRect: CGRect.init(x: paddingX, y: paddingY, width: intWidth, height: intHeight), cornerRadius: 0.0)
        externalPath.append(internalPath)
        externalPath.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer.init()
        fillLayer.path = externalPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.35
        
        overlayView.layer.addSublayer(fillLayer)
         
        //bordas:
        let borderPath = UIBezierPath.init()
        
        //top left:
        borderPath.move(to: CGPoint.init(x: paddingX + 1.0, y: paddingY + 25.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + 1.0, y: paddingY + 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + 25.0, y: paddingY + 1.0))
        //top right:
        borderPath.move(to: CGPoint.init(x: paddingX + intWidth - 26.0, y: paddingY + 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + intWidth - 1.0, y: paddingY + 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + intWidth - 1.0, y: paddingY + 25.0))
        //bottom left:
        borderPath.move(to: CGPoint.init(x: paddingX + 1.0, y: paddingY + intHeight - 26.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + 1.0, y: paddingY + intHeight - 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + 25.0, y: paddingY + intHeight - 1.0))
        //bottom right:
        borderPath.move(to: CGPoint.init(x: paddingX + intWidth - 26.0, y: paddingY + intHeight - 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + intWidth - 1.0, y: paddingY + intHeight - 1.0))
        borderPath.addLine(to: CGPoint.init(x: paddingX + intWidth - 1.0, y: paddingY + intHeight - 26.0))
        
        let borderLayer = CAShapeLayer.init()
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = UIColor.RGBA(255, 204, 0, 255).cgColor //amarelo camera sistema
        borderLayer.lineCap = .round
        borderLayer.lineWidth = 4.0
        borderLayer.fillColor = nil
        
        overlayView.layer.addSublayer(borderLayer)
        
        return overlayView
    }
    
    
    
    
    
}
