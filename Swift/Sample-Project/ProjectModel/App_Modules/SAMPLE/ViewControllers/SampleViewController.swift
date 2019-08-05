//
//  SampleViewController.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 28/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit
import AVFoundation

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • LOCAL DEFINES / ENUMS

//MARK: - • CLASS

class SampleViewController: ModelViewController, SampleManagerViewControllerProtocol {

    //MARK: - • PUBLIC PROPERTIES
    
    @IBOutlet weak var imvAnimation:UIImageView!
    //
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    //
    var bubble:UIBubbleView?
    var textComposer = TextComposer()
    
    //MARK: - • PRIVATE PROPERTIES
    
    private lazy var viewModel: SampleManagerProtocol = SampleManager(self)
    
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
        
        let imv:UIImageView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        imv.contentMode = .scaleAspectFill
        imv.backgroundColor = UIColor.clear
        imv.image = UIImage.init(named: "fish.jpg")!
        imv.clipsToBounds = true
        imv.layer.cornerRadius = 5.0
        imv.tag = 1
        
        //let rect = AVMakeRect(aspectRatio: imv.image!.size, insideRect: imv.frame)
        
        bubble = UIBubbleView.defaultBubble()
        bubble?.setBubbleContent(view: imv)
        bubble?.setPosition(center: self.view.center)
        self.view.addSubview(bubble!)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(actionTakePhoto(sender:)))
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var img:UIImage? = nil
        var staticImg:UIImage = UIImage.init(named: "fish.jpg")!
        
        //        img = UIImage.init(named: "animation.gif")!
        
        //        do {
        //            try img = UIImage.animatedImageWithAnimatedGIF(data: Data.init(contentsOf: Bundle.main.url(forResource: "animation", withExtension: "gif")!))!
        //        }catch(let error){
        //            print(error.localizedDescription)
        //        }
        
        //        img:UIImage = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)!
        
        //        img:UIImage = UIImage.init(named: "animation.gif")!.imageRotated(byDegrees: 45.0)
        
        //        img = UIImage.init(named: "animation.gif")!.imageFlippedVertically()
        
        //        img = UIImage.init(named: "animation.gif")!.imageFlippedHorizontally()
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.resizedImageToSize(CGSize.init(width: 50.0, height: 50.0))
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.resizedImageToScale(0.05)
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.resizedImageToFrameSize(CGSize.init(width: 50.0, height: 80.0))
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.cropImageUsingFrame(CGRect.init(x: 50.0, y: 50.0, width: 100.0, height: 100.0))
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.circularCropImageUsingFrame(CGRect.init(x: 100.0, y: 100.0, width: 300.0, height: 300.0))
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.roundedCornerImage(radius: 50.0, corners: .allCorners)
        
        //        staticImg = staticImg.applyFilter(name: "CISepiaTone", parameters: ["inputIntensity":01.0]) //CISepiaTone
        
        //        staticImg = staticImg.compressImage(quality: 0.05)
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)?.compressImage(quality: 0.01)
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)
        //        staticImg = staticImg.mergeImageAbove(anotherImage: img!, position: CGPoint.zero, blendMode: .normal, alpha: 0.5, scale: 0.5)
        
        //        img = UIImage.animatedImageWithAnimatedGIF(url: Bundle.main.url(forResource: "animation", withExtension: "gif")!)
        //        staticImg = staticImg.mergeImageBelow(anotherImage: img!, position: CGPoint.zero, blendMode: .normal, alpha: 0.5, scale: 0.5)
        
        //        let mask:UIImage = UIImage.init(named: "mask_gray.jpg")!
        //        staticImg = staticImg.maskWithGrayscaleImage(maskImage: mask)
        
        //        let mask:UIImage = UIImage.init(named: "mask_alpha.png")!
        //        staticImg = staticImg.maskWithAlphaImage(maskImage: mask)
        
        //        let mask:UIImage = UIImage.init(named: "mask_alpha.png")!.tintImage(color: UIColor.green)
        
        //        staticImg = staticImg.bluredImage(radius: 10.0, grayMaskImage: UIImage.init(named: "mask_gray.jpg")!)
        //        staticImg = staticImg.bluredImage(radius: 10.0)
        
        //        let faces = UIImage(named: "faces1.jpg")!
        //        faces.detectFacesImages { (detectedFaces:[UIImage]) in
        //            var faces:[UIImage] = Array()
        //            for face in detectedFaces {
        //                let newFace = face.resizedImageToSize(detectedFaces[0].size)
        //                faces.append(newFace)
        //            }
        //            let gif = UIImage.animatedImage(with: faces, duration: 10.0)
        //            self.imvAnimation.image = gif
        //        }
        
        //        let faces = UIImage(named: "qrcode.png")!
        //        faces.detectQRCodeMessages { (detectedMessages:[String]) in
        //            for str in detectedMessages {
        //                print(str)
        //            }
        //        }
        
        //        var tshirt = UIImage(named: "blue_tshirt.jpg")!
        //        tshirt = tshirt.transmuteColor(from: UIColor.init(red: 52.0/255.0, green: 106.0/255.0, blue: 215.0/255.0, alpha: 1.0), to: UIColor.init(red: 213.0/255.0, green: 65.0/255.0, blue: 231.0/255.0, alpha: 1.0), tolerance: 0.4, interestAreas: [CGRect.init(x: 0.0, y: tshirt.size.height / 4.0, width: tshirt.size.width / 2.0, height: tshirt.size.height / 2.0)])
        
        //        var tshirt = UIImage(named: "chroma_key.jpg")!
        //        tshirt = tshirt.labeledImage(text: "Helena!", contentRect: CGRect(x: 0.0, y: tshirt.size.height / 2.0, width: tshirt.size.width, height: 40.0), rectCorners: .allCorners, cornerSize: CGSize(width: 10.0, height: 10.0), textAligment: .center, internalMargin: UIEdgeInsets.zero, font: UIFont.boldSystemFont(ofSize: 20.0), fontColor: UIColor.red, backgroundColor: UIColor.yellow, shadow: nil, autoHeightAdjust: false)
        
        //        var tshirt = UIImage(named: "blue_tshirt.jpg")!
        //        tshirt = tshirt.filterColor(targetHue: 240.0/360.0, tolerance: 15.0/360.0)
        
        //        var tshirt = UIImage(named: "blue_tshirt.jpg")!
        //        let thumb = tshirt.createThumbnail(128)
        
        //        var tshirt = UIImage(named: "blue_tshirt.jpg")!
        //        let img1 = tshirt.monochromaticBWImage(intensity: .normal)
        //        let img2 = tshirt.monochromaticBWImage(intensity: .low)
        //        let img3 = tshirt.monochromaticBWImage(intensity: .high)
        
        //        var img1 = UIImage(named: "color1.jpg")!
        //        var img2 = UIImage(named: "color2.jpg")!
        //        //
        //        img1.extractColors(withFlags: [.onlyBrightColors], avoidColor: UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), count: 3) { colors in
        //            print("\(colors.count)")
        //        }
        //        //
        //        img2.extractColors(withFlags: [.onlyDistinctColors], avoidColor: UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), count: 3) { colors in
        //            print("\(colors.count)")
        //        }
        
        //        let pxColor = staticImg.pixelColor(atLocation: CGPoint.init(x: 100.0, y: 100.0))
        
//        let face = UIImage(named: "face.jpg")!
//        let base64 = face.encodeToBase64String()
//        face.detectFacesImages { (detectedFaces:[UIImage]) in
//            var faces:[UIImage] = Array()
//            for face in detectedFaces {
//                let newFace = face.resizedImageToSize(detectedFaces[0].size)
//                faces.append(newFace)
//            }
//            let gif = UIImage.animatedImage(with: faces, duration: 10.0)
//            self.imvAnimation.image = gif
//        }
        
        let imageToExtractColors = UIImage(named: "faces1.jpg")!
        imageToExtractColors.extractColors(withFlags: [.onlyDistinctColors], avoidColor: nil, count: 4) { colors in
            if colors.count > 0 {
                self.view.backgroundColor = colors[0]
            }
            if colors.count > 1 {
                self.lbl1.textColor = colors[1]
            }
            if colors.count > 2 {
                self.lbl2.textColor = colors[2]
            }
            if colors.count > 3 {
                self.lbl3.textColor = colors[3]
            }
        }

        imvAnimation.image = imageToExtractColors
        
        
        let face = UIImage(named: "faces1.jpg")!
        face.detectFacesImages { (detectedFaces:[UIImage]) in
            var faces:[UIImage] = Array()
            for face in detectedFaces {
                let newFace = face.resizedImageToSize(detectedFaces[0].size)
                faces.append(newFace)
            }
            let gif = UIImage.animatedImage(with: faces, duration: 10.0)
            //
            if let iv = self.bubble?.viewWithTag(1) as? UIImageView {
                iv.image = gif
            }
        }
        
        
     
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var attribute1 = Dictionary<NSAttributedString.Key, Any>()
        attribute1[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        attribute1[NSAttributedString.Key.foregroundColor] = UIColor.red
        
        var attribute2 = Dictionary<NSAttributedString.Key, Any>()
        attribute2[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18.0)
        attribute2[NSAttributedString.Key.foregroundColor] = UIColor.blue
        
        var attribute3 = Dictionary<NSAttributedString.Key, Any>()
        attribute3[.font] = UIFont.italicSystemFont(ofSize: 15.0)
        attribute3[NSAttributedString.Key.foregroundColor] = UIColor.green
        
        var attribute4 = Dictionary<NSAttributedString.Key, Any>()
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage.init(named: "fish.jpg")!
        attachment.bounds = CGRect.init(x: 0.0, y: 0.0, width: (UIFont.systemFontSize * (attachment.image!.size.width / attachment.image!.size.height)), height: UIFont.systemFontSize)
        attribute4[.attachment] = attachment
        
        textComposer.register(style: attribute1, withName: TextComposer.normal)
        textComposer.register(style: attribute2, withName: TextComposer.bold)
        textComposer.register(style: attribute3, withName: TextComposer.italic)
        textComposer.register(style: attribute4, withName: TextComposer.attachment)
        
        textComposer.append(text: "Teste de ", styleIdentifier: TextComposer.normal)
        textComposer.append(text: "TEXTO ATRIBUIDO ", styleIdentifier: TextComposer.bold)
        textComposer.append(text: "para componente ", styleIdentifier: TextComposer.normal)
        textComposer.append(text: "personalizado!  ", styleIdentifier: TextComposer.italic)
        //
        textComposer.append(attachment: attachment, styleIdentifier: TextComposer.attachment)
        
        lbl4.attributedText = textComposer.attributedString()
        
        
    }
    
    //Super Methods
    
    override func setupLayout() {
        super.defaultSetup("Title")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: bubble)
        //
        if (bubble!.frame.contains((touch?.location(in: self.view))!)){
            bubble!.tag = 1
        }else{
            bubble?.setLinkTarget(point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: bubble)
        //
        if bubble!.tag == 1 {
            bubble!.setPosition(center:touch!.location(in: self.view))
        }else{
            bubble?.setLinkTarget(point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: bubble)
        //
        if bubble!.tag == 1 {
            bubble!.tag = 0
            bubble!.setPosition(center:touch!.location(in: self.view))
            //
            self.showActivityIndicator(inStatusBar: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideActivityIndicator(inStatusBar: true)
            }
        } else {
            bubble?.setLinkTarget(point)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: bubble)
        //
        if bubble!.tag == 1 {
            bubble!.tag = 0
            bubble!.setPosition(center:touch!.location(in: self.view))
        } else {
            bubble?.setLinkTarget(point)
        }
    }
    
    //MARK: - • CONTROLLER LIFECYCLE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    //ViewControllerProtocol
    
    func showLoading() {
        self.showActivityIndicator(inStatusBar: true)
    }
    
    func hideLoading() {
        self.hideActivityIndicator(inStatusBar: true)
    }
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionTakePhoto(sender:Any?) -> Void {
        self.segue(to: "SegueToPhoto", backButtonTitle: "Voltar")
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    
    
}
