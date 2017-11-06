//
//  PMAlertView.swift
//  Etna
//
//  Created by Erico GT on 29/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • ENUMS

public enum PMAlertViewOptionType: Int {
    case normal         = 1
    case extra          = 2
    case cancel         = 3
}

public enum PMAlertViewIconType: Int {
    case none         = 0
    case custom       = 1
    case check        = 2
    case cart         = 3
    case money        = 4
    case menu         = 5
}

public enum PMAlertViewType: Int {
    case custom            = 0
    case authentication    = 1
    case success           = 2
    case error             = 3
    case info              = 4
    case warning           = 5
    case question          = 6
    case edit              = 7
    case exclusion         = 8
    case share             = 9
    case no_connection     = 10
    //
    
    func toString() -> String{
        switch self {
        case .custom:
            return NSLocalizedString("PMALERTVIEW_TYPE_CUSTOM", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .authentication:
            return NSLocalizedString("PMALERTVIEW_TYPE_AUTHENTICATION", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .success:
            return  NSLocalizedString("PMALERTVIEW_TYPE_SUCCESS", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .error:
            return  NSLocalizedString("PMALERTVIEW_TYPE_ERROR", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .info:
            return  NSLocalizedString("PMALERTVIEW_TYPE_INFO", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .warning:
            return  NSLocalizedString("PMALERTVIEW_TYPE_WARNING", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .question:
            return  NSLocalizedString("PMALERTVIEW_TYPE_QUESTION", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .edit:
            return  NSLocalizedString("PMALERTVIEW_TYPE_EDIT", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .exclusion:
            return  NSLocalizedString("PMALERTVIEW_TYPE_EXCLUSION", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .share:
            return  NSLocalizedString("PMALERTVIEW_TYPE_SHARE", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        case .no_connection:
            return  NSLocalizedString("PMALERTVIEW_TYPE_NO_CONNECTION", tableName: "PMAlertViewLocalizable", bundle: Bundle.main, value: "", comment: "")
        }
    }
}

//MARK: - • CLASS

public class PMAlertView: UIView, UITextFieldDelegate {
    
    //Ao utilizar o bloco de retorno desta forma não é necessário @escaping.
    public typealias CompletionHandler = () -> ()
    
    //MARK: - • LOCAL DEFINES
    
    //MARK: - • PUBLIC PROPERTIES
    public var inputedText:String? = nil
    
    //MARK: - • PRIVATE PROPERTIES
    private weak var vcOwner:UIViewController? = nil
    private weak var delegate:PMAlertViewDelegate? = nil
    private weak var dataSource:PMAlertViewDataSource? = nil
    //
    private let ANIMA_TIME:TimeInterval = 0.2
    private var isVisible:Bool = false;
    private var options:[AlertOption] = Array.init()
    //
    private var useInputField:Bool = false
    private var inputFieldMask:String? = nil
    private var maxLenghtField:Int = 0
    //
    @IBOutlet private var viewBackground:UIView!
    @IBOutlet private var scrollViewBackground:UIScrollView!
    @IBOutlet private var imvBackground:UIImageView!
    @IBOutlet private var viewContainer:UIView!
    @IBOutlet private var imvIcon:UIImageView!
    @IBOutlet private var txtMessage:UITextView!
    @IBOutlet private var txtInput:ASTextField!
    //
    @IBOutlet private var constraitTopGuideDistance:NSLayoutConstraint!
    @IBOutlet private var constraitContainerViewHeight:NSLayoutConstraint!
    @IBOutlet private var constraitTextViewHeight:NSLayoutConstraint!
    
    //MARK: - • INITIALISERS
    
    //storyboard initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //programmatic initializer
    init() {
        super.init(frame: CGRect())
    }
    
    class func new(owner:UIViewController) -> PMAlertView{
        
        let av:PMAlertView = UINib(nibName: String(describing: PMAlertView.self), bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! PMAlertView
        //lv.translatesAutoresizingMaskIntoConstraints = true
        //
        av.vcOwner = owner
        av.layoutIfNeeded()
        av.setupLayout()
        //
        return av
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtInput) {
            let strValidated:String? = txtInput.validateText(inputMask: inputFieldMask, maxLenght:maxLenghtField, range: range, textFieldString:textField.text ?? "", replacementString: string, charactersRestriction: nil)
            if let str:String = strValidated {
                textField.text = str
            }
            return false
        }
     
        return true
    }
    
    //MARK: - • PUBLIC METHODS
    
    @discardableResult public func addOption(_ optType:PMAlertViewOptionType, _ optTitle:String, _ optIcon:PMAlertViewIconType, _ optIdentifier:String?, _ optAction:CompletionHandler?) -> Bool {
        
        if (options.count > 2) {
            return false
        }else {
            
            let newOption:AlertOption = AlertOption.init(optType, optTitle, optIdentifier ?? "", optAction)
            
            let y:CGFloat = CGFloat(options.count + 1) * 14.0 +  CGFloat(options.count) * 50.0
            //
            let button:UIButton = UIButton.init(type: .custom)
            button.frame = CGRect.init(x: 14.0, y: y, width: viewContainer.frame.size.width, height: 50.0)
            button.backgroundColor = UIColor.clear
            button.layer.borderWidth = 1.0
            button.setTitle(optTitle, for: .normal)
            button.isExclusiveTouch = true
            button.semanticContentAttribute = .forceLeftToRight
            button.tag = options.count
            
            switch optType {
            case .normal:
                
                button.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: button.frame.size, corners: .allCorners, cornerRadius: CGSize.zero, color: App.Style.colorView_RedDefault), for: .normal)
                button.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: button.frame.size, corners: .allCorners, cornerRadius: CGSize.zero, color: App.Style.colorView_RedDark), for: .highlighted)
                button.layer.borderColor = App.Style.colorView_RedDark.cgColor
                button.setTitleColor(App.Style.colorText_White, for: .normal)
                if (optIcon != .none) {
                    let icon1:UIImage? = self.buttonIconImage(type: optIcon, optIdentifier:optIdentifier, color: App.Style.colorText_White)
                    button.setImage(icon1, for: .normal)
                }
                button.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_BOLD, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
                
            case .extra:
                
                button.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: button.frame.size, corners: .allCorners, cornerRadius: CGSize.zero, color: App.Style.colorView_Dark), for: .normal)
                button.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: button.frame.size, corners: .allCorners, cornerRadius: CGSize.zero, color: App.Style.colorView_Dark), for: .highlighted)
                button.layer.borderColor = App.Style.colorView_Dark.cgColor
                button.setTitleColor(App.Style.colorText_White, for: .normal)
                if (optIcon != .none) {
                    let icon1:UIImage? = self.buttonIconImage(type: optIcon, optIdentifier:optIdentifier, color: App.Style.colorText_White)
                    button.setImage(icon1, for: .normal)
                }
                button.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_BOLD, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
                
            case .cancel:
                
                button.layer.borderWidth = 0.0
                button.setTitleColor(App.Style.colorText_White, for: .normal)
                button.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_BOLD, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
            }
            //
            button.addTarget(self, action: #selector(actionButton(_ :)), for: .touchUpInside)
            self.viewBackground.addSubview(button)
            //
            newOption.button = button
            //
            options.append(newOption)
            
            return true
        }
    }
    
    public func setupInputField(visible:Bool, placeholder:String, inputMask:String?, maxLenght:Int, keyboardType:UIKeyboardType, secure:Bool) {
        
        useInputField = visible
        //
        txtInput.text = ""
        txtInput.placeholder = placeholder
        txtInput.keyboardType = keyboardType
        txtInput.isSecureTextEntry = secure
        //
        inputFieldMask = inputMask
        maxLenghtField = maxLenght
        
    }
    
    public func setDelegate(_ del:PMAlertViewDelegate) {
        self.delegate = del
    }
    
    public func setDataSource(_ dSource:PMAlertViewDataSource) {
        self.dataSource = dSource
    }
    
    public func show(_ type:PMAlertViewType!, _ message:String!) {
        
        DispatchQueue.main.async {
            
            self.layoutIfNeeded()
            
            if (!self.isVisible){
                
                //Keyboard Notifications:
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
                
                //Icon
                self.imvIcon.image = self.alertIconImage(type: type, color: App.Style.colorText_GrayDark)
                
                //Input
                self.txtInput.text = ""
                self.inputedText = nil
                
                //Message
                let text:NSMutableAttributedString = NSMutableAttributedString.init(string: message)
                let font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_LABEL_NORMAL)
                text.addAttributes([NSAttributedStringKey.font : font as Any], range: NSRange.init(location: 0, length: message.count))
                self.txtMessage.attributedText = text
                self.txtMessage.textAlignment = .center
                self.txtMessage.textColor = App.Style.colorText_GrayDark
               
                let maxHeight:CGFloat = self.frame.size.height * 0.90
                
                self.txtMessage.isScrollEnabled = false
                let txtSize:CGSize = self.txtMessage.sizeThatFits(CGSize.init(width: self.txtMessage.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
                self.txtMessage.isScrollEnabled = true
                
                let offset:CGFloat = 10.0
                self.txtMessage.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
                //
                var actualHeight:CGFloat = 14.0 + 50.0 + 14.0
                actualHeight += txtSize.height + offset
                if (self.useInputField) {
                    actualHeight += 64
                    self.txtInput.alpha = 1.0
                }
                actualHeight += 14.0
                actualHeight += (CGFloat(self.options.count) * 64.0)
                
                //Tamanho da caixa de texto
                if (actualHeight > maxHeight) {
                    self.constraitTextViewHeight.constant = txtSize.height + offset - (actualHeight - maxHeight)
                    self.txtMessage.isScrollEnabled = true
                }else{
                    self.constraitTextViewHeight.constant = txtSize.height + offset
                    self.txtMessage.isScrollEnabled = false
                }
                
                //Tamanho da view container
                self.constraitContainerViewHeight.constant = 14.0 + 50.0 + 14.0 + self.constraitTextViewHeight.constant
                if (self.useInputField) {
                    self.constraitContainerViewHeight.constant += 64
                }
                self.constraitContainerViewHeight.constant += 14.0
                
                //Distância até o topo
                self.constraitTopGuideDistance.constant = (self.frame.height - (self.constraitContainerViewHeight.constant + CGFloat(self.options.count) * 64.0)) / 2.0
                
                self.layoutIfNeeded()
                
                //Buttons
                for i:Int in 0...(self.options.count-1) {
                    
                    let option = self.options[i]
                    
                    if let b = option.button {
                        
                        b.frame = CGRect.init(x: 14.0, y: (self.constraitTopGuideDistance.constant + self.constraitContainerViewHeight.constant) + (CGFloat(i) * 50.0) + (CGFloat(i + 1) * 14.0), width: b.frame.size.width, height: b.frame.size.height)
                        
                    }
                }
                
                App.Delegate.window?.addSubview(self)
                App.Delegate.window?.bringSubview(toFront: self)
                self.isVisible = true
                //
                self.scaleAnimation(self)
                //
                UIView.animate(withDuration: self.ANIMA_TIME, animations: {
                    self.alpha = 1.0
                }, completion: { (finished) in
                    print("alert visible!")
                })
                
            }
            
        }
    }
    
    
    //MARK: - • ACTION METHODS
    
    @objc private func actionButton(_ sender:UIButton){
        
        if (useInputField) {
            inputedText = txtInput.text
        }else{
            inputedText = nil
        }
        
        var canHide:Bool = true
        
        if (!ToolBox.isNil(self.delegate)) {
            
            let option:AlertOption = self.options[sender.tag]
            
            let alertResult = (delegate?.alertViewShouldFinalize(av: self, optionIdentifier: option.identifier))!
            
            if (!alertResult.finalize) {
                
                canHide = false
                
                if let errorM:String = alertResult.errorMessage {
                    
                    self.txtInput.showError(message: errorM)  
                }
                
                if let alternativeM:String = alertResult.alternativeMessage {
                    
                    self.txtMessage.text = alternativeM
                    //
                    self.updateAlertUI()
                }
            }
        }
        
        if (canHide) {
            
            //Animações e fechamento
            self.scaleAnimation(self)
            //
            UIView.animate(withDuration: self.ANIMA_TIME, animations: {
                self.alpha = 0.0
            }, completion: { (finished) in
                
                self.isVisible = false
                self.txtInput.alpha = 0.0
                self.useInputField = false
                //
                DispatchQueue.main.async {
                    let option:AlertOption = self.options[sender.tag]
                    option.action?()
                    //
                    for option:AlertOption in self.options {
                        if let b = option.button {
                            b.removeFromSuperview()
                        }
                    }
                    self.options.removeAll()
                }
            })
            
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        }

    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout(){
    
        self.frame = (App.Delegate.window?.frame)!
        
        //
        self.backgroundColor = UIColor.clear
        //
        self.viewBackground.backgroundColor = UIColor.clear
        //
        self.imvBackground.image = nil
        self.imvBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        //
        self.viewContainer.backgroundColor = UIColor.white
        self.viewContainer.layer.borderWidth = 1.0
        self.viewContainer.layer.borderColor = App.Style.colorView_Light.cgColor
        //
        self.imvIcon.backgroundColor = UIColor.clear
        //
        self.txtMessage.backgroundColor = UIColor.clear
        self.txtMessage.text = ""
        //
        App.Style.updateLayout(textField: &txtInput)
        self.txtInput.text = ""
        self.txtInput.alpha = 0.0
        //
        self.constraitTopGuideDistance.constant = 100
        self.constraitContainerViewHeight.constant = 100
        self.constraitTextViewHeight.constant = 100
        //
        self.layoutIfNeeded()
        self.alpha = 0.0
    }
    
    
    private func scaleAnimation(_ view:UIView){
        
        let scaleAnima:CABasicAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnima.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        scaleAnima.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1))
        scaleAnima.duration = ANIMA_TIME / 2.0
        scaleAnima.autoreverses = true
        scaleAnima.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        scaleAnima.isRemovedOnCompletion = true
        //
        view.layer.add(scaleAnima, forKey: "ScaleAnimation")
    }
    
    private func buttonIconImage(type:PMAlertViewIconType, optIdentifier:String?, color:UIColor) -> UIImage {
        
        switch type {
            
        case .none:
            return UIImage.init()
            
        case .custom:
            
            if let image = self.dataSource?.alertViewImageForCustomOption(av: self, identifier: optIdentifier) {
                return image
            }else{
                return UIImage.init()
            }
            
        case .check:
            return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "CheckMark"))!
            
        case .cart:
            return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-place"))!
        
        case .money:
            return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-place"))!
            
        case .menu:
            return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-place"))!
        }
    }
    
    private func alertIconImage(type:PMAlertViewType, color:UIColor) -> UIImage {
        
        switch type {
        
            case .custom:
            
                if let image = self.dataSource?.alertViewImageForCustomType(av: self) {
                    return image
                }else{
                    return UIImage.init()
                }
                
            case .authentication:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-authentication"))!
                
            case .success:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-success"))!
                
            case .error:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-error"))!
                
            case .info:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-info"))!
                
            case .warning:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-warning"))!
                
            case .question:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-question"))!
                
            case .edit:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-edit"))!
                
            case .exclusion:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-exclusion"))!
                
            case .share:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-share"))!
            
            case .no_connection:
                return ToolBox.Graphic.tintImage(tintColor: color, templateImage: UIImage.init(named: "icon-alert-no_connection"))!
            
        }
    }
    
    private func updateAlertUI() {
        
        //Message
        let text:NSMutableAttributedString = NSMutableAttributedString.init(string: txtMessage.text)
        let font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_LABEL_NORMAL)
        text.addAttributes([NSAttributedStringKey.font : font as Any], range: NSRange.init(location: 0, length: self.txtMessage.text.count))
        self.txtMessage.attributedText = text
        self.txtMessage.textAlignment = .center
        self.txtMessage.textColor = App.Style.colorText_GrayDark
        
        let maxHeight:CGFloat = self.frame.size.height * 0.90
        
        self.txtMessage.isScrollEnabled = false
        let txtSize:CGSize = self.txtMessage.sizeThatFits(CGSize.init(width: self.txtMessage.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        self.txtMessage.isScrollEnabled = true
        
        let offset:CGFloat = 10.0
        self.txtMessage.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        //
        var actualHeight:CGFloat = 14.0 + 50.0 + 14.0
        actualHeight += txtSize.height + offset
        if (self.useInputField) {
            actualHeight += 64
            self.txtInput.alpha = 1.0
        }
        actualHeight += 14.0
        actualHeight += (CGFloat(self.options.count) * 64.0)
        
        //Tamanho da caixa de texto
        if (actualHeight > maxHeight) {
            self.constraitTextViewHeight.constant = txtSize.height + offset - (actualHeight - maxHeight)
            self.txtMessage.isScrollEnabled = true
        }else{
            self.constraitTextViewHeight.constant = txtSize.height + offset
            self.txtMessage.isScrollEnabled = false
        }
        
        //Tamanho da view container
        self.constraitContainerViewHeight.constant = 14.0 + 50.0 + 14.0 + self.constraitTextViewHeight.constant
        if (self.useInputField) {
            self.constraitContainerViewHeight.constant += 64
        }
        self.constraitContainerViewHeight.constant += 14.0
        
        //Distância até o topo
        self.constraitTopGuideDistance.constant = (self.frame.height - (self.constraitContainerViewHeight.constant + CGFloat(self.options.count) * 64.0)) / 2.0
        
        self.layoutIfNeeded()
        
        //Buttons
        for i:Int in 0...(self.options.count-1) {
            
            let option = self.options[i]
            
            if let b = option.button {
                
                b.frame = CGRect.init(x: 14.0, y: (self.constraitTopGuideDistance.constant + self.constraitContainerViewHeight.constant) + (CGFloat(i) * 50.0) + (CGFloat(i + 1) * 14.0), width: b.frame.size.width, height: b.frame.size.height)
                
            }
        }
    }
    
    @objc private func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollViewBackground.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
    }
    
    @objc private func keyboardWillHide(notification:Notification) {
        scrollViewBackground.contentInset = .zero
    }
    
}

//MARK: - AUX. CLASSES

fileprivate class AlertOption{
    
    typealias CompletionHandler = () -> Void
    
    var type:PMAlertViewOptionType = .normal
    var title:String = ""
    var identifier:String? = ""
    var action:CompletionHandler?
    var button:UIButton?
    
    init(_ ty:PMAlertViewOptionType, _ ti:String, _ id:String, _ ac:CompletionHandler?) {
        self.type = ty
        self.title = ti
        self.identifier = id
        self.action = ac
        self.button = nil
    }
}


public class AlertResult{
    
    var finalize:Bool = true
    var errorMessage:String? = ""
    var alternativeMessage:String? = ""
    
    init(_ finalizeAlert:Bool, _ inputMessageError:String?, _ mainAlternativeMessage:String?){
        self.finalize = finalizeAlert
        self.errorMessage = inputMessageError
        self.alternativeMessage = mainAlternativeMessage
    }
}


//MARK: - PROTOCOLS

public protocol PMAlertViewDelegate:NSObjectProtocol
{
    func alertViewShouldFinalize(av:PMAlertView, optionIdentifier:String?) -> AlertResult!
}


public protocol PMAlertViewDataSource:NSObjectProtocol
{
    func alertViewImageForCustomOption(av:PMAlertView, identifier:String?) -> UIImage!
    func alertViewImageForCustomType(av:PMAlertView) -> UIImage!
}
