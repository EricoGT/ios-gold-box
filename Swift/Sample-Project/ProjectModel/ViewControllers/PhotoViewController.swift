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
        
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .camera
        photoPicker.cameraDevice = .front
        
    
        
        self.present(photoPicker, animated: true) {
            
            //Vision Face Track
//            let v = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: photoPicker.view.frame.size.width, height: photoPicker.view.frame.size.height))
//            v.backgroundColor = .red
//            
//            photoPicker.cameraOverlayView = v
            
            print("x")
        }
        
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
}
