//
//  ASTextField.swift
//  Etna
//
//  Created by Erico GT on 16/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//Originalmente:

//
//  DTTextField.swift
//  Pods
//
//  Created by Dhaval Thanki on 03/04/17.
//
//

import Foundation
import UIKit

public extension String {
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}

//extension Character
//{
//    func unicodeScalarCodePoint() -> UInt32
//    {
//        let characterString = String(self)
//        let scalars = characterString.unicodeScalars
//        
//        return scalars[scalars.startIndex].value
//    }
//}

public class ASTextField: UITextField {
    
    public enum FloatingDisplayStatus{
        case always
        case never
        case defaults
    }
    
    fileprivate var lblFloatPlaceholder:UILabel             = UILabel()
    fileprivate var lblError:UILabel                        = UILabel()
    
    fileprivate let paddingX:CGFloat                        = 10.0 //5.0
    
    fileprivate let paddingHeight:CGFloat                   = 10.0
    
    public var asLayer:CALayer                              = CALayer()
    public var floatPlaceholderColor:UIColor                = UIColor.black
    public var floatPlaceholderActiveColor:UIColor          = UIColor.black
    public var floatingLabelShowAnimationDuration           = 0.3
    public var floatingDisplayStatus:FloatingDisplayStatus  = .defaults
    
    public var errorMessage:String = ""{
        didSet{ lblError.text = errorMessage }
    }
    
    public var animateFloatPlaceholder:Bool = true
    public var hideErrorWhenEditing:Bool   = true
    
    public var errorFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var floatPlaceholderFont = UIFont.systemFont(ofSize: 10.0){
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYFloatLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYErrorLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var borderColor:UIColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0){
        didSet{ asLayer.borderColor = borderColor.cgColor }
    }
    
    public var canShowBorder:Bool = true{
        didSet{ asLayer.isHidden = !canShowBorder }
    }
    
    public var placeholderColor:UIColor?{
        didSet{
            guard let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal, attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    public var errorColorView:UIColor?{
        didSet{
            guard let color = errorColorView else { return }
            lblError.textColor = color
        }
    }
    
    public var normalColorView:UIColor?
    
    @IBOutlet var spaceBottomConstrait:NSLayoutConstraint?{
        didSet{
            if spaceBottomConstrait != nil {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    public var extraPaddingForBottomConstrait:CGFloat = 5.0
    
    fileprivate var x:CGFloat {
        
        if let leftView = leftView {
            return leftView.frame.origin.x + leftView.bounds.size.width + paddingX
        }
        
        return paddingX
    }
    
    fileprivate var fontHeight:CGFloat{
        return ceil(font!.lineHeight)
    }
    
    fileprivate var asLayerHeight:CGFloat{
        //ericogt
        //return showErrorLabel ? floor(bounds.height - lblError.bounds.size.height - paddingYErrorLabel) : bounds.height
        return bounds.height
    }
    
    fileprivate var floatLabelWidth:CGFloat{
        
        var width = bounds.size.width
        
        if let leftViewWidth = leftView?.bounds.size.width{
            width -= leftViewWidth
        }
        
        if let rightViewWidth = rightView?.bounds.size.width {
            width -= rightViewWidth
        }
        
        return width - (self.x * 2)
    }
    
    fileprivate var placeholderFinal:String{
        if let attributed = attributedPlaceholder { return attributed.string }
        return placeholder ?? " "
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    fileprivate var showErrorLabel:Bool = false{
        didSet{
            
            guard showErrorLabel != oldValue else { return }
            
            guard showErrorLabel else {
                hideErrorMessage()
                return
            }
            
            guard !errorMessage.isEmptyStr else { return }
            showErrorMessage()
        }
    }
    
    override public var borderStyle: UITextField.BorderStyle{
        didSet{
            guard borderStyle != oldValue else { return }
            borderStyle = .none
        }
    }
    
    public override var text: String?{
        didSet{ self.textFieldTextChanged() }
    }
    
    override public var placeholder: String?{
        didSet{
            
            guard let color = placeholderColor else {
                lblFloatPlaceholder.text = placeholderFinal
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    override public var attributedPlaceholder: NSAttributedString?{
        didSet{ lblFloatPlaceholder.text = placeholderFinal }
    }
    
    //MARK: - METHODS:
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func showError(message:String? = nil) {
        if let msg = message { errorMessage = msg }
        showErrorLabel = true
    }
    
    public func hideError()  {
        showErrorLabel = false
    }
    
    public func clearText() -> String{
        
        let filteredString:String = (self.text?.removeCharacters(from: CharacterSet.init(charactersIn: App.Constants.TEXT_MASK_DEFAULT_CHARS_SET)))!
        return filteredString
    }
    
    public func validateText(inputMask:String?, maxLenght:Int, range:NSRange, textFieldString:String, replacementString:String, charactersRestriction:String?) -> String? {
        
        // Prevent crashing undo bug
        if (range.length + range.location > textFieldString.count) {
            return nil
        }
        
        //Mask validation:
        if let mask:String = inputMask {
            
            var changedString:String = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
            
            var ignore:Bool = false
            
            let subString:String = (textFieldString as NSString).substring(with: range)
            let rangeSub:Range? = subString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "0123456789"))
            
            if ((range.length == 1) && (replacementString.count < range.length) && (rangeSub == nil)) {
                
                var location:Int = changedString.count - 1
                
                if (location > 0) {
                    
                    for index in stride(from: location, through: 1, by: -1) {
                        
                        if (CharacterSet.init(charactersIn: "0123456789").contains(UnicodeScalar((changedString as NSString).character(at: index))!)) {
                            location = index;
                            break
                        }
                    }
                    changedString = (changedString as NSString).substring(to: location)
                    
                }else {
                    ignore = true
                }
            }
            
            if (ignore) {
                return nil
            }else {
                return filteredString(fromString:(changedString as NSString), filter:(mask as NSString))
            }
        
        }else{
            
            //Max lenght validation:
            if (maxLenght > 0) {
                
                let newLength:Int = textFieldString.count + replacementString.count - range.length
                if (newLength > maxLenght) {
                    return nil
                }
            }
                
            //Characters validation:
            if let chars:String = charactersRestriction {
                
                let characterset = CharacterSet(charactersIn: chars)
                if replacementString.rangeOfCharacter(from: characterset.inverted) != nil {
                    //O texto possui caracteres inválidos
                    return nil
                }else{
                    var newText = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
                    newText = newText.removeCharacters(from: CharacterSet.init(charactersIn: "~˜^ˆ'`¨"))
                    return newText
                }
                
            }else{
                //Normal success return
                let newText = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
                return newText
            }
            
        }
    
    }
    
    private func filteredString(fromString:NSString, filter:NSString) -> String {
        
        var onOriginal:Int = 0
        var onFilter:Int = 0
        var onOutput:Int = 0
        var outputString = [Character](repeating: "\0", count:filter.length)
        var done:Bool = false
        
        while (onFilter < filter.length && !done) {
            
            let filterChar:Character = Character(UnicodeScalar(filter.character(at: onFilter))!)
            let originalChar:Character = onOriginal >= fromString.length ? "\0" : Character(UnicodeScalar(fromString.character(at: onOriginal))!)
            
            switch filterChar {
            case "#":
                
                if (originalChar == "\0") {
                    // We have no more input numbers for the filter.  We're done.
                    done = true
                    break
                }
                
                if (CharacterSet.init(charactersIn: "0123456789").contains(UnicodeScalar(originalChar.unicodeScalarCodePoint())!)) {
                    outputString[onOutput] = originalChar;
                    onOriginal += 1
                    onFilter += 1
                    onOutput += 1
                }else{
                    onOriginal += 1
                }
                
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput += 1
                onFilter += 1
                if(originalChar == filterChar) {
                    onOriginal += 1
                }
            }
        }
        
        if (onOutput < outputString.count){
            outputString[onOutput] = "\0" // Cap the output string
        }
        
        return String(outputString).replacingOccurrences(of: "\0", with: "")
    }
    
    //MARK: -
    
    fileprivate func commonInit() {
        
        asLayer.cornerRadius        = 4.5
        asLayer.borderWidth         = 0.5
        asLayer.borderColor         = borderColor.cgColor
        asLayer.backgroundColor     = UIColor.white.cgColor
        
        floatPlaceholderColor       = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        floatPlaceholderActiveColor = tintColor
        lblFloatPlaceholder.frame   = CGRect.zero
        lblFloatPlaceholder.alpha   = 0.0
        lblFloatPlaceholder.font    = floatPlaceholderFont
        lblFloatPlaceholder.text    = placeholderFinal
        lblFloatPlaceholder.tag     = 101
        
        addSubview(lblFloatPlaceholder)
        
        errorColorView = UIColor.red
        normalColorView = UIColor.lightGray
        
        lblError.frame              = CGRect.zero
        lblError.font               = errorFont
        lblError.textColor          = errorColorView
        lblError.numberOfLines      = 0
        lblError.isHidden           = true
        
        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        addSubview(lblError)
        
        layer.insertSublayer(asLayer, at: 0)
    }
    
    fileprivate func showErrorMessage(){
        
        lblError.text = errorMessage
        lblError.isHidden = false
        let boundWithPadding = CGSize(width: bounds.width - (x * 2), height: bounds.height)
        let errorLabelSize =  lblError.sizeThatFits(boundWithPadding)
        lblError.frame = CGRect(x: paddingX, y: 0, width: errorLabelSize.width, height: errorLabelSize.height)
        invalidateIntrinsicContentSize()
        //
        if (canShowBorder){
            asLayer.borderColor = errorColorView?.cgColor
        }else{
            asLayer.borderColor = UIColor.clear.cgColor
        }
        
        spaceBottomConstrait?.constant += (lblError.frame.size.height + extraPaddingForBottomConstrait)
    }
    
    fileprivate func hideErrorMessage(){
        
        spaceBottomConstrait?.constant -= (lblError.frame.size.height + extraPaddingForBottomConstrait)
        
        lblError.text = ""
        lblError.isHidden = true
        lblError.frame = CGRect.zero
        invalidateIntrinsicContentSize()
        //
        if (canShowBorder){
            asLayer.borderColor = normalColorView?.cgColor
        }else{
            asLayer.borderColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate func showFloatingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 1.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.paddingYFloatLabel,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func hideFlotingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 0.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.lblFloatPlaceholder.font.lineHeight,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        
        return CGRect(x: x, y: 0, width: rect.width - paddingX * 2, height: rect.height) //ericogt
        
//        guard showErrorLabel else { return CGRect(x: x, y: 0, width: rect.width - paddingX, height: rect.height) }
//        
//        let topInset = (rect.size.height - lblError.bounds.size.height - paddingYErrorLabel - fontHeight) / 2.0
//        let textY = topInset - ((rect.height - fontHeight) / 2.0)
//        
//        return CGRect(x: x, y: floor(textY), width: rect.size.width - paddingX, height: rect.size.height)
    }
    
    fileprivate func insetRectForBounds(rect:CGRect) -> CGRect {
        
        guard let _ = lblFloatPlaceholder.text else {
            return insetRectForEmptyBounds(rect: rect)
        }
        //guard !lblFloatPlaceholder.text.isEmptyStr else { return insetRectForEmptyBounds(rect: rect) }
        
        if floatingDisplayStatus == .never {
            return insetRectForEmptyBounds(rect: rect)
        }else{
            
            if let text = text,text.isEmptyStr && floatingDisplayStatus == .defaults {
                return insetRectForEmptyBounds(rect: rect)
            }else{
                let topInset = paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + (paddingHeight / 2.0)
                let textOriginalY = (rect.height - fontHeight) / 2.0
                var textY = topInset - textOriginalY
                
                if textY < 0 && !showErrorLabel { textY = topInset }
                
                return CGRect(x: x, y: ceil(textY), width: rect.size.width - paddingX, height: rect.height)
            }
        }
    }
    
    @objc fileprivate func textFieldTextChanged(){
        
        if (hideErrorWhenEditing && showErrorLabel) {
            showErrorLabel = false
        }
//        guard hideErrorWhenEditing && showErrorLabel else { return }
//        showErrorLabel = false

        
        
        
        
        
        
    }
    
    override public var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        lblError.sizeToFit()
        
        if showErrorLabel {
            lblFloatPlaceholder.sizeToFit()
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingYErrorLabel + lblFloatPlaceholder.bounds.size.height + lblError.bounds.size.height + paddingHeight)
        }else{
            return CGSize(width: textFieldIntrinsicContentSize.width,
                          height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + paddingHeight)
        }
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    fileprivate func insetForSideView(forBounds bounds: CGRect) -> CGRect{
        var rect = bounds
        rect.origin.y = 0
        rect.size.height = asLayerHeight
        return rect
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (asLayerHeight - rect.size.height) / 2
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        asLayer.frame = CGRect(x: bounds.origin.x,
                               y: bounds.origin.y,
                               width: bounds.width,
                               height: asLayerHeight)
        CATransaction.commit()
        
        if showErrorLabel {
            
            var lblErrorFrame = lblError.frame
            lblErrorFrame.origin.y = asLayer.frame.origin.y + asLayer.frame.size.height + paddingYErrorLabel
            lblError.frame = lblErrorFrame
        }
        
        let floatingLabelSize = lblFloatPlaceholder.sizeThatFits(lblFloatPlaceholder.superview!.bounds.size)
        
        lblFloatPlaceholder.frame = CGRect(x: x, y: lblFloatPlaceholder.frame.origin.y,
                                           width: floatingLabelSize.width,
                                           height: floatingLabelSize.height)
        
        lblFloatPlaceholder.textColor = isFirstResponder ? floatPlaceholderActiveColor : floatPlaceholderColor
        
        switch floatingDisplayStatus {
        case .never:
            hideFlotingLabel(isFirstResponder)
        case .always:
            showFloatingLabel(isFirstResponder)
        default:
            if let enteredText = text,!enteredText.isEmptyStr{
                showFloatingLabel(isFirstResponder)
            }else{
                hideFlotingLabel(isFirstResponder)
            }
        }
    }
}

