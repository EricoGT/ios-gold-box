//
//  SCLAlertViewPlus.swift
//  Project-Swift
//
//  Created by Erico GT on 05/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import SCLAlertView

//MARK: - Enums and Extensions

enum SCLAlertButtonType: Int {
    case Default         = 0
    case Neutral         = 1
    case Success         = 2
    case Error           = 3
    case Notice          = 4
    case Warning         = 5
    case Info            = 6
    case Edit            = 7
    case Wait            = 8
}

//MARK: - SCLAlertViewPlus
class SCLAlertViewPlus:SCLAlertView{
    
    required init() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium),
            kTextFont: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
            kButtonFont: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium),
            showCloseButton: false
        )
        
        super.init(appearance: appearance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Class Funcs
    
    class func createDefaultAlert() -> SCLAlertViewPlus{
        
        let alert:SCLAlertViewPlus = SCLAlertViewPlus.init()
        //
        return alert
    }
    
    class func createRichAlert(bodyMessage:String, images:Array<UIImage>, animationTimePerFrame:TimeInterval) -> SCLAlertViewPlus{
        
        let alert:SCLAlertViewPlus = SCLAlertViewPlus.init()
        
        let font:UIFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        
        let alertWidth:CGFloat = 216 //fixo pela superclass
        
        //TextField
        let label:UILabel = UILabel(frame: CGRect(x: 0.0, y: 10.0, width: alertWidth, height: bodyMessage.height(withConstrainedWidth: 216, font: font)))
        label.textColor = UIColor.gray
        label.font = font
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = bodyMessage
        
        //UIImageView
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: (label.frame.size.height + 20.0), width: alertWidth, height: 100))
        imageView.backgroundColor = nil
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.image = UIImage(named: "animal.jpg")
        imageView.animationImages = images
        imageView.animationDuration = animationTimePerFrame * Double(images.count)
        imageView.startAnimating()
        
        //CustomView
        let subview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: alertWidth, height: (10.0 + label.frame.size.height + 10.0 + imageView.frame.size.height)))
        subview.addSubview(label)
        subview.addSubview(imageView)
        //
        alert.customSubview = subview
        
        return alert
    }
    
    //MARK: - Personalized Methods
    
    let appearance = SCLAlertView.SCLAppearance(
        showCircularIcon: false
    )
    
    func addButton(title:String, type:SCLAlertButtonType, action:@escaping () -> Void){
        
        var color:UIColor?
        
        switch type {
            case .Default:
                color = nil
                
            case .Neutral:
                color = UIColor.lightGray
            
            case .Success:
                color = self.UIColorFromRGB(0x22B573)
            
            case .Error:
                color = self.UIColorFromRGB(0xC1272D)
            
            case .Notice:
                color = self.UIColorFromRGB(0x727375)
            
            case .Warning:
                color = self.UIColorFromRGB(0xFFD110)
            
            case .Info:
                color = self.UIColorFromRGB(0x2866BF)
            
            case .Edit:
                color = self.UIColorFromRGB(0xA429FF)
            
            case .Wait:
                color = self.UIColorFromRGB(0xD62DA5)
        }

        super.addButton(title, backgroundColor: color, textColor: UIColor.white, showTimeout: nil) {
            action()
        }
    }
    
    //MARK: - Private Methods
    
    private func RGBFromUIColor(color:UIColor) -> UInt{
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var colorAsUInt32 : UInt32 = 0
        colorAsUInt32 += UInt32(red * 255.0) << 16
        colorAsUInt32 += UInt32(green * 255.0) << 8
        colorAsUInt32 += UInt32(blue * 255.0)
        
        let colorAsUInt = UInt(colorAsUInt32)
        
        return colorAsUInt
    }
    
    private func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
