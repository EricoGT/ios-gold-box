//
//  ViewController.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imvAnimation:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        var tshirt = UIImage(named: "blue_tshirt.jpg")!
        tshirt = tshirt.transmuteColor(from: UIColor.init(red: 52.0/255.0, green: 106.0/255.0, blue: 215.0/255.0, alpha: 1.0), to: UIColor.init(red: 213.0/255.0, green: 65.0/255.0, blue: 231.0/255.0, alpha: 1.0), tolerance: 0.4, interestAreas: [CGRect.init(x: 0.0, y: tshirt.size.height / 4.0, width: tshirt.size.width / 2.0, height: tshirt.size.height / 2.0)])
        
//        var tshirt = UIImage(named: "chroma_key.jpg")!
//        tshirt = tshirt.labeledImage(text: "Helena!", contentRect: CGRect(x: 0.0, y: tshirt.size.height / 2.0, width: tshirt.size.width, height: 40.0), rectCorners: .allCorners, cornerSize: CGSize(width: 10.0, height: 10.0), textAligment: .center, internalMargin: UIEdgeInsets.zero, font: UIFont.boldSystemFont(ofSize: 20.0), fontColor: UIColor.red, backgroundColor: UIColor.yellow, shadow: nil, autoHeightAdjust: false)
        
//        var tshirt = UIImage(named: "blue_tshirt.jpg")!
//        tshirt = tshirt.filterColor(targetHue: 240.0/360.0, tolerance: 15.0/360.0)
        
        
        imvAnimation.image = tshirt
    }

}

