//
//  LayoutManager.swift
//  Project-Swift
//
//  Created by Erico GT on 04/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit
import Kingfisher

enum AppStyle: Int {
    case Default    = 0
    case Light      = 1
    case Dark       = 2
    case Special    = 3
}

class LayoutStyleManager:NSObject{
    
    //Properties:
    var style:AppStyle
    
    //Componentes gerais (bordas, fundos, etc)
    var colorView_SuperLight:UIColor
    var colorView_Light:UIColor
    var colorView_Normal:UIColor
    var colorView_Dark:UIColor
    var colorView_SuperDark:UIColor
    //
    var colorView_RedDefault:UIColor
    var colorView_RedDark:UIColor
    //
    var colorView_GreenDefault:UIColor
    var colorView_GreenDark:UIColor
    
    //Textos
    var colorText_White:UIColor
    //
    var colorText_GrayDefault:UIColor
    var colorText_GrayDark:UIColor
    //
    var colorText_RedDefault:UIColor
    var colorText_RedDark:UIColor
    //
    var colorText_GreenDefault:UIColor
    var colorText_GreenDark:UIColor
    //
    var colorText_BlueDefault:UIColor
    var colorText_BlueDark:UIColor
    
    
    //Initializers:
    override init(){
        self.style = .Default
        //
        colorView_SuperLight = UIColor.white
        colorView_Light = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        colorView_Normal = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        colorView_Dark = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        colorView_SuperDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        //
        colorView_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        colorView_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        //
        colorView_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        colorView_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        
        //Textos
        colorText_White = UIColor.white
        //
        colorText_GrayDefault = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        colorText_GrayDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
        //
        colorText_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
        colorText_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        //
        colorText_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        colorText_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        //
        colorText_BlueDefault = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        colorText_BlueDark = UIColor.init(red: 7.0/255.0, green: 56.0/255.0, blue: 109.0/255.0, alpha: 1.0)
    }
    
    func setStyle(_ style:AppStyle){
        
        //MARK: Para criar aplicações com set de estilos, implementar as variações abaixo:
        switch style {
        case .Default, .Light, .Dark, .Special:
            self.style = .Default
            //
            colorView_SuperLight = UIColor.white
            colorView_Light = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            colorView_Normal = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            colorView_Dark = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            colorView_SuperDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            //
            colorView_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            colorView_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            //
            colorView_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
            colorView_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
            
            //Textos
            colorText_White = UIColor.white
            //
            colorText_GrayDefault = UIColor.init(red: 109.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            colorText_GrayDark = UIColor.init(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            //
            colorText_RedDefault = UIColor.init(red: 220.0/255.0, green: 40.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            colorText_RedDark = UIColor.init(red: 188.0/255.0, green: 7.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            //
            colorText_GreenDefault = UIColor.init(red: 117.0/255.0, green: 180.0/255.0, blue: 49.0/255.0, alpha: 1.0)
            colorText_GreenDark = UIColor.init(red: 79.0/255.0, green: 136.0/255.0, blue: 17.0/255.0, alpha: 1.0)
            //
            colorText_BlueDefault = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            colorText_BlueDark = UIColor.init(red: 7.0/255.0, green: 56.0/255.0, blue: 109.0/255.0, alpha: 1.0)
            
            //        case .Light:
            //            break
            //
            //        case .Dark:
            //            break
            //
            //        case .Special:
            //            break
            
        }
    }
    
    func updateLayout(textField: inout ASTextField!){
        
        textField.canShowBorder = true
        textField.asLayer.borderColor = colorView_Normal.cgColor
        textField.asLayer.borderWidth = 1.0
        textField.asLayer.cornerRadius = 0.0
        //Padding
        textField.paddingYFloatLabel = 8.0
        textField.extraPaddingForBottomConstrait = 2.0
        //Colors
        textField.textColor = colorText_GrayDark
        textField.errorColorView = colorText_RedDefault
        textField.normalColorView = colorView_Normal
        //Placeholder
        textField.floatPlaceholderFont = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_LABEL_MINI)!
        textField.placeholderColor = UIColor.gray
        textField.floatPlaceholderColor = UIColor.gray
        //Font
        textField.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        //Ajustando o tamanho dos textos:
        textField.minimumFontSize = App.Constants.FONT_SIZE_TEXT_FIELDS / 2.0
        textField.adjustsFontSizeToFitWidth = true
        //Ajustando o tamanho para o placeholder:
        for  subView in textField.subviews {
            if let label = subView as? UILabel {
                
                label.adjustsFontSizeToFitWidth = true
                if (label.tag == 101) {
                    //floating placeholder
                    label.minimumScaleFactor = 0.5
                }else{
                    //normal placeholder
                    label.minimumScaleFactor = 0.5
                }
            }
        }
    }
    
    func createActivityIndicatorImageView(color:UIColor, position:ActivityIndicatorImageView.IndicatorPosition, parentImageView:UIImageView) -> ActivityIndicatorImageView{
        
        let aiiv:ActivityIndicatorImageView = ActivityIndicatorImageView.init(style: .whiteLarge)
        aiiv.color = color
        aiiv.parentIV = parentImageView
        aiiv.positionInImageView = position
        //
        return aiiv
    }
    
    func createAccessoryView(targetView:UIView, selector:Selector) -> UIView{
        
        let view:UIView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        view.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        //
        let btnApply:UIButton = UIButton.init(frame: CGRect.init(x: view.frame.size.width/2, y: 0.0, width: view.frame.size.width/2, height: 44.0))
        btnApply.contentHorizontalAlignment = .right
        btnApply.addTarget(targetView, action: selector, for: .touchUpInside)
        btnApply.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 14.0)
        btnApply.setTitleColor(self.colorText_BlueDefault, for: .normal)
        btnApply.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
        btnApply.setTitle(App.STR("BUTTON_TITLE_ACCESSORY_VIEW_DONE"), for: .normal)
        //
        view.addSubview(btnApply)
        //
        return view
    }
    
}

class ActivityIndicatorImageView:UIActivityIndicatorView, Indicator{
    
    enum IndicatorPosition: Int {
        case TopLeft            = 0
        case TopCenter          = 1
        case TopRight           = 2
        //
        case MidleLeft          = 3
        case MidleCenter        = 4
        case MidleRight         = 5
        //
        case BottomLeft         = 6
        case BottomCenter       = 7
        case BottomRight        = 8
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func startAnimatingView(){
        self.startAnimating()
    }
    
    func stopAnimatingView(){
        self.stopAnimating()
    }
    
    var viewCenter: CGPoint {
        get{
            return self.center
        }
        set{
            if (parentIV != nil){
                switch positionInImageView {
                case .TopLeft:
                    self.center = CGPoint.init(x: 37.0, y: 37.0)
                case .TopCenter:
                    self.center = CGPoint.init(x: ((parentIV?.frame.size.width)! / 2.0), y: 37.0)
                case .TopRight:
                    self.center = CGPoint.init(x: (parentIV?.frame.size.width)! - 37.0, y: 37.0)
                //
                case .MidleLeft:
                    self.center = CGPoint.init(x: 37.0, y: ((parentIV?.frame.size.height)! / 2.0))
                case .MidleCenter:
                    self.center = CGPoint.init(x: ((parentIV?.frame.size.width)! / 2.0), y: ((parentIV?.frame.size.height)! / 2.0))
                case .MidleRight:
                    self.center = CGPoint.init(x: (parentIV?.frame.size.width)! - 37.0, y: ((parentIV?.frame.size.height)! / 2.0))
                //
                case .BottomLeft:
                    self.center = CGPoint.init(x: 37.0, y: (parentIV?.frame.size.height)! - 37.0 - 10.0)
                case .BottomCenter:
                    self.center = CGPoint.init(x: ((parentIV?.frame.size.width)! / 2.0), y: (parentIV?.frame.size.height)! - 37.0)
                case .BottomRight:
                    self.center = CGPoint.init(x: (parentIV?.frame.size.width)! - 37.0, y: (parentIV?.frame.size.height)! - 37.0)
                }
            }else{
                self.center = newValue
            }
        }}
    
    var view: IndicatorView {
        get{
            return self
        }
    }
    
    //internal
    var positionInImageView:IndicatorPosition = .MidleCenter
    var parentIV:UIImageView? = nil
    
    private func commonInit(){
        self.color = UIColor.white
        self.hidesWhenStopped = true
    }
}
