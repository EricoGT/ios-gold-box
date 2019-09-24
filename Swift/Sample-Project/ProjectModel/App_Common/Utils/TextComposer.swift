//
//  TextComposer.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 04/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

class TextComposer {
    
    public enum StyleName: String {
        
        //Nomes pré-definidos
        
        case T1 = "T1"
        case T2 = "T2"
        case T3 = "T3"
        case T4 = "T4"
        case T5 = "T5"
        
        case Normal = "Normal"
        case Special = "Special"
        
        case Regular = "Regular"
        case Bold = "Bold"
        case Medium = "Medium"
        case Italic = "Italic"
        case Underline = "Underline"
        case Strikethrough = "Strikethrough"
        case Link = "Link"
        
        case Attachment1 = "Attachment1"
        case Attachment2 = "Attachment2"
        case Attachment3 = "Attachment3"
        
        case Body = "Body"
        case Callout = "Callout"
        case Caption1 = "Caption1"
        case Caption2 = "Caption2"
        case Footnote = "Footnote"
        case Headline = "Headline"
        case Subhead = "Subhead"
        case LargeTitle = "LargeTitle"
        case Title1 = "Title1"
        case Title2 = "Title2"
        case Title3 = "Title3"
        
        case Subtitle1 = "Subtitle1"
        case Subtitle2 = "Subtitle2"
        case Subtitle3 = "Subtitle3"
        
        //RawValue
        var raw: String {
            return self.rawValue
        }
    }
    
    public enum FontType {
        
        //Roboto-Family
        case RobotoRegular
        case RobotoLight
        case RobotoLightItalic
        case RobotoMedium
        case RobotoBold
        
        //Insert others here...
        //case
        //case
        //case
        
        
        //Font name in system:
        var value: String {
            switch self {
            case .RobotoRegular:
                return "Roboto-Regular"
            case .RobotoLight:
                return "Roboto-Light"
            case .RobotoLightItalic:
                return "Roboto-LightItalic"
            case .RobotoMedium:
                return "Roboto-Medium"
            case .RobotoBold:
                return "Roboto-Bold"
            }
        }
    }
    
    //MARK: Private Properties
    
    private var styleList:Dictionary<String, Dictionary<NSAttributedString.Key, Any>> = Dictionary()
    private var textList:[Dictionary<String, NSAttributedString>] = Array()
    private var str:NSMutableAttributedString = NSMutableAttributedString()
    
    //MARK: Methods
    
    private func updateText() -> Void {
        str = NSMutableAttributedString()
        //
        for dic in textList {
            for key in dic.keys {
                str.append(dic[key]!)
            }
        }
    }
    
    func font(_ fontType:FontType, _ size:CGFloat) -> UIFont {
        return UIFont.init(name: fontType.value, size: size) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    func register(style:Dictionary<NSAttributedString.Key,Any>, withName:String) -> Void {
        styleList[withName] = style
    }
    
    func register(font:UIFont, color:UIColor, withName:String) -> Void {
        var attribute = Dictionary<NSAttributedString.Key, Any>()
        attribute[NSAttributedString.Key.font] = font
        attribute[NSAttributedString.Key.foregroundColor] = color
        //
        styleList[withName] = attribute
    }
    
    func unregister(styleIdentifier:String) -> Void {
        styleList[styleIdentifier] = nil
    }
    
    /// Concatena um texto contendo um estilo pré registrado.
    func append(text:String, styleIdentifier:String) -> Void {
        if styleList.keys.contains(styleIdentifier) {
            let attributes = styleList[styleIdentifier]
            let string = NSAttributedString.init(string: text, attributes: attributes)
            textList.append([styleIdentifier:string])
            //
            self.updateText()
        }
    }
    
    /// Concatena um anexo contento um estilo pré registrado.
    func append(attachment:NSTextAttachment, styleIdentifier:String) -> Void {
        if styleList.keys.contains(styleIdentifier) {
            let string = NSAttributedString.init(attachment: attachment)
            textList.append([styleIdentifier:string])
            //
            self.updateText()
        }
    }
    
    /// Insire um bloco de texto atribuído, numa posição específica.
    func insert(text:String, styleIdentifier:String, at:Int) -> Void {
        if styleList.keys.contains(styleIdentifier) {
            let attributes = styleList[styleIdentifier]
            let string = NSAttributedString.init(string: text, attributes: attributes)
            if at < self.textList.count {
                textList.insert([styleIdentifier:string], at: at)
                //
                self.updateText()
            }
            
        }
    }
    
    /// Remove um bloco de texto na posição especificada.
    func removeText(at:Int) -> Void {
        if at < self.textList.count {
            textList.remove(at: at)
            //
            self.updateText()
        }
    }
    
    /// Remove todas as ocorrências de blocos de texto que possuam o estilo parâmetro.
    func removeText(withStyleIdentifier:String) -> Void {
        textList.removeAll { (dic) -> Bool in
            return dic.first?.key == withStyleIdentifier
        }
        //
        self.updateText()
    }
    
    /// Remove todo o texto contido na composição.
    func clear() -> Void {
        textList.removeAll()
        str = NSMutableAttributedString()
    }
    
    /// Texto atribuído da composição.
    func attributedString() -> NSAttributedString {
        return NSAttributedString.init(attributedString: str)
    }
    
    /// Representa o texto puro (sem atribuições) da composição.
    func string() -> String {
        return str.string
    }
    
    /// Retorna o conjunto de atribuições para um dado estilo.
    func style(forIdentifier:String) -> Dictionary<NSAttributedString.Key,Any> {
        if let dic = self.styleList[forIdentifier] {
            return dic
        }
        return Dictionary()
    }
    
//    private func attributedStringLink(text:String) -> NSAttributedString {
//        var attributes:[NSAttributedString.Key : Any] = [NSAttributedString.Key : Any]()
//        attributes[NSAttributedString.Key.link] = text
//        attributes[NSAttributedString.Key.font] = Font.init(name: "OpenSans-Regular", size: 16.0)
//        //NOTE: link attributes are 'textView' properties
//        var linkAttributes:[String : Any] = [String : Any]()
//        linkAttributes[NSAttributedString.Key.foregroundColor.rawValue] = UIColor().primaryColor
//        linkAttributes[NSAttributedString.Key.underlineColor.rawValue] = UIColor().primaryColor
//        linkAttributes[NSAttributedString.Key.underlineStyle.rawValue] = NSUnderlineStyle.styleSingle.rawValue
//        textTextView.linkTextAttributes = linkAttributes
//        //
//        let string = NSAttributedString.init(string: text, attributes: attributes)
//        return string
//    }
}


public class TextValidator {
    
    public func clearMask(set:String, from:String) -> String{
        let set = CharacterSet.init(charactersIn: set)
        let components = from.components(separatedBy: set)
        return components.joined(separator: "")
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
                    //newText = newText.removeCharacters(from: CharacterSet.init(charactersIn: "~˜^ˆ'`¨"))
                    newText = self.clearMask(set: "~˜^ˆ'`¨", from: newText)
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
    
}

/*

 Lista de nomes disponíveis (XCode 10.3)
 
------------------------------
Font Family Name = [Devanagari Sangam MN]
Font Names = [["DevanagariSangamMN", "DevanagariSangamMN-Bold"]]
    ------------------------------
Font Family Name = [Avenir Next]
Font Names = [["AvenirNext-Medium", "AvenirNext-DemiBoldItalic", "AvenirNext-DemiBold", "AvenirNext-HeavyItalic", "AvenirNext-Regular", "AvenirNext-Italic", "AvenirNext-MediumItalic", "AvenirNext-UltraLightItalic", "AvenirNext-BoldItalic", "AvenirNext-Heavy", "AvenirNext-Bold", "AvenirNext-UltraLight"]]
    ------------------------------
Font Family Name = [Kohinoor Devanagari]
Font Names = [["KohinoorDevanagari-Regular", "KohinoorDevanagari-Light", "KohinoorDevanagari-Semibold"]]
    ------------------------------
Font Family Name = [Times New Roman]
Font Names = [["TimesNewRomanPS-ItalicMT", "TimesNewRomanPS-BoldItalicMT", "TimesNewRomanPS-BoldMT", "TimesNewRomanPSMT"]]
    ------------------------------
Font Family Name = [Gill Sans]
Font Names = [["GillSans-Italic", "GillSans-SemiBold", "GillSans-UltraBold", "GillSans-Light", "GillSans-Bold", "GillSans", "GillSans-SemiBoldItalic", "GillSans-BoldItalic", "GillSans-LightItalic"]]
    ------------------------------
Font Family Name = [Kailasa]
Font Names = [["Kailasa-Bold", "Kailasa"]]
    ------------------------------
Font Family Name = [Bradley Hand]
Font Names = [["BradleyHandITCTT-Bold"]]
    ------------------------------
Font Family Name = [PingFang HK]
Font Names = [["PingFangHK-Medium", "PingFangHK-Thin", "PingFangHK-Regular", "PingFangHK-Ultralight", "PingFangHK-Semibold", "PingFangHK-Light"]]
    ------------------------------
Font Family Name = [Savoye LET]
Font Names = [["SavoyeLetPlain"]]
    ------------------------------
Font Family Name = [Trebuchet MS]
Font Names = [["TrebuchetMS-Bold", "TrebuchetMS-Italic", "Trebuchet-BoldItalic", "TrebuchetMS"]]
    ------------------------------
Font Family Name = [Baskerville]
Font Names = [["Baskerville-SemiBoldItalic", "Baskerville-SemiBold", "Baskerville-BoldItalic", "Baskerville", "Baskerville-Bold", "Baskerville-Italic"]]
    ------------------------------
Font Family Name = [Futura]
Font Names = [["Futura-CondensedExtraBold", "Futura-Medium", "Futura-Bold", "Futura-CondensedMedium", "Futura-MediumItalic"]]
    ------------------------------
Font Family Name = [Arial Hebrew]
Font Names = [["ArialHebrew-Bold", "ArialHebrew-Light", "ArialHebrew"]]
    ------------------------------
Font Family Name = [Bodoni 72]
Font Names = [["BodoniSvtyTwoITCTT-Bold", "BodoniSvtyTwoITCTT-BookIta", "BodoniSvtyTwoITCTT-Book"]]
    ------------------------------
Font Family Name = [Hoefler Text]
Font Names = [["HoeflerText-Italic", "HoeflerText-Black", "HoeflerText-Regular", "HoeflerText-BlackItalic"]]
    ------------------------------
Font Family Name = [Optima]
Font Names = [["Optima-ExtraBlack", "Optima-BoldItalic", "Optima-Italic", "Optima-Regular", "Optima-Bold"]]
    ------------------------------
Font Family Name = [DIN Condensed]
Font Names = [["DINCondensed-Bold"]]
    ------------------------------
Font Family Name = [Noto Nastaliq Urdu]
Font Names = [["NotoNastaliqUrdu"]]
    ------------------------------
Font Family Name = [Charter]
Font Names = [["Charter-BlackItalic", "Charter-Bold", "Charter-Roman", "Charter-Black", "Charter-BoldItalic", "Charter-Italic"]]
    ------------------------------
Font Family Name = [Heiti TC]
Font Names = [[]]
    ------------------------------
Font Family Name = [Geeza Pro]
Font Names = [["GeezaPro-Bold", "GeezaPro"]]
    ------------------------------
Font Family Name = [Bodoni Ornaments]
Font Names = [["BodoniOrnamentsITCTT"]]
    ------------------------------
Font Family Name = [Kohinoor Telugu]
Font Names = [["KohinoorTelugu-Regular", "KohinoorTelugu-Medium", "KohinoorTelugu-Light"]]
    ------------------------------
Font Family Name = [Helvetica Neue]
Font Names = [["HelveticaNeue-UltraLightItalic", "HelveticaNeue-Medium", "HelveticaNeue-MediumItalic", "HelveticaNeue-UltraLight", "HelveticaNeue-Italic", "HelveticaNeue-Light", "HelveticaNeue-ThinItalic", "HelveticaNeue-LightItalic", "HelveticaNeue-Bold", "HelveticaNeue-Thin", "HelveticaNeue-CondensedBlack", "HelveticaNeue", "HelveticaNeue-CondensedBold", "HelveticaNeue-BoldItalic"]]
    ------------------------------
Font Family Name = [Party LET]
Font Names = [["PartyLetPlain"]]
    ------------------------------
Font Family Name = [Symbol]
Font Names = [["Symbol"]]
    ------------------------------
Font Family Name = [Bangla Sangam MN]
Font Names = [[]]
    ------------------------------
Font Family Name = [Hiragino Sans]
Font Names = [["HiraginoSans-W3", "HiraginoSans-W6"]]
    ------------------------------
Font Family Name = [Hiragino Maru Gothic ProN]
Font Names = [["HiraMaruProN-W4"]]
    ------------------------------
Font Family Name = [Cochin]
Font Names = [["Cochin-Italic", "Cochin-Bold", "Cochin", "Cochin-BoldItalic"]]
    ------------------------------
Font Family Name = [Euphemia UCAS]
Font Names = [["EuphemiaUCAS", "EuphemiaUCAS-Italic", "EuphemiaUCAS-Bold"]]
    ------------------------------
Font Family Name = [Academy Engraved LET]
Font Names = [["AcademyEngravedLetPlain"]]
    ------------------------------
Font Family Name = [Helvetica]
Font Names = [["Helvetica-Oblique", "Helvetica-BoldOblique", "Helvetica", "Helvetica-Light", "Helvetica-Bold", "Helvetica-LightOblique"]]
    ------------------------------
Font Family Name = [American Typewriter]
Font Names = [["AmericanTypewriter-CondensedBold", "AmericanTypewriter-Condensed", "AmericanTypewriter-CondensedLight", "AmericanTypewriter", "AmericanTypewriter-Bold", "AmericanTypewriter-Semibold", "AmericanTypewriter-Light"]]
    ------------------------------
Font Family Name = [Didot]
Font Names = [["Didot-Bold", "Didot", "Didot-Italic"]]
    ------------------------------
Font Family Name = [Courier New]
Font Names = [["CourierNewPS-ItalicMT", "CourierNewPSMT", "CourierNewPS-BoldItalicMT", "CourierNewPS-BoldMT"]]
    ------------------------------
Font Family Name = [Courier]
Font Names = [["Courier-BoldOblique", "Courier-Oblique", "Courier", "Courier-Bold"]]
    ------------------------------
Font Family Name = [Rockwell]
Font Names = [["Rockwell-Italic", "Rockwell-Regular", "Rockwell-Bold", "Rockwell-BoldItalic"]]
    ------------------------------
Font Family Name = [Palatino]
Font Names = [["Palatino-Italic", "Palatino-Roman", "Palatino-BoldItalic", "Palatino-Bold"]]
    ------------------------------
Font Family Name = [Comfortaa]
Font Names = [["Comfortaa-Bold", "Comfortaa-Regular"]]
    ------------------------------
Font Family Name = [Mishafi]
Font Names = [["DiwanMishafi"]]
    ------------------------------
Font Family Name = [Malayalam Sangam MN]
Font Names = [["MalayalamSangamMN-Bold", "MalayalamSangamMN"]]
    ------------------------------
Font Family Name = [Avenir Next Condensed]
Font Names = [["AvenirNextCondensed-Heavy", "AvenirNextCondensed-MediumItalic", "AvenirNextCondensed-Regular", "AvenirNextCondensed-UltraLightItalic", "AvenirNextCondensed-Medium", "AvenirNextCondensed-HeavyItalic", "AvenirNextCondensed-DemiBoldItalic", "AvenirNextCondensed-Bold", "AvenirNextCondensed-DemiBold", "AvenirNextCondensed-BoldItalic", "AvenirNextCondensed-Italic", "AvenirNextCondensed-UltraLight"]]
    ------------------------------
Font Family Name = [Snell Roundhand]
Font Names = [["SnellRoundhand", "SnellRoundhand-Bold", "SnellRoundhand-Black"]]
    ------------------------------
Font Family Name = [Heiti SC]
Font Names = [[]]
    ------------------------------
Font Family Name = [Damascus]
Font Names = [["DamascusBold", "DamascusLight", "Damascus", "DamascusMedium", "DamascusSemiBold"]]
    ------------------------------
Font Family Name = [Lao Sangam MN]
Font Names = [["LaoSangamMN"]]
    ------------------------------
Font Family Name = [Oriya Sangam MN]
Font Names = [["OriyaSangamMN", "OriyaSangamMN-Bold"]]
    ------------------------------
Font Family Name = [Papyrus]
Font Names = [["Papyrus-Condensed", "Papyrus"]]
    ------------------------------
Font Family Name = [Copperplate]
Font Names = [["Copperplate-Light", "Copperplate", "Copperplate-Bold"]]
    ------------------------------
Font Family Name = [Thonburi]
Font Names = [["Thonburi", "Thonburi-Light", "Thonburi-Bold"]]
    ------------------------------
Font Family Name = [Sinhala Sangam MN]
Font Names = [["SinhalaSangamMN-Bold", "SinhalaSangamMN"]]
    ------------------------------
Font Family Name = [Kohinoor Bangla]
Font Names = [["KohinoorBangla-Regular", "KohinoorBangla-Semibold", "KohinoorBangla-Light"]]
    ------------------------------
Font Family Name = [Chalkboard SE]
Font Names = [["ChalkboardSE-Bold", "ChalkboardSE-Light", "ChalkboardSE-Regular"]]
    ------------------------------
Font Family Name = [Noteworthy]
Font Names = [["Noteworthy-Bold", "Noteworthy-Light"]]
    ------------------------------
Font Family Name = [Farah]
Font Names = [["Farah"]]
    ------------------------------
Font Family Name = [Arial]
Font Names = [["Arial-BoldMT", "Arial-BoldItalicMT", "Arial-ItalicMT", "ArialMT"]]
    ------------------------------
Font Family Name = [Hiragino Mincho ProN]
2019-09-20 09:11:12.552549-0300 DebugCartaoPB[8539:2994126] TIC TCP Conn Failed [1:0x2807ec840]: 1:50 Err(50)
Font Names = [["HiraMinProN-W3", "HiraMinProN-W6"]]
------------------------------
Font Family Name = [Georgia]
Font Names = [["Georgia-BoldItalic", "Georgia-Italic", "Georgia", "Georgia-Bold"]]
------------------------------
Font Family Name = [Verdana]
Font Names = [["Verdana-Italic", "Verdana", "Verdana-Bold", "Verdana-BoldItalic"]]
------------------------------
Font Family Name = [DIN Alternate]
Font Names = [["DINAlternate-Bold"]]
------------------------------
Font Family Name = [Apple Color Emoji]
Font Names = [["AppleColorEmoji"]]
------------------------------
Font Family Name = [PingFang SC]
Font Names = [["PingFangSC-Medium", "PingFangSC-Semibold", "PingFangSC-Light", "PingFangSC-Ultralight", "PingFangSC-Regular", "PingFangSC-Thin"]]
------------------------------
Font Family Name = [Chalkduster]
Font Names = [["Chalkduster"]]
------------------------------
Font Family Name = [PingFang TC]
Font Names = [["PingFangTC-Regular", "PingFangTC-Thin", "PingFangTC-Medium", "PingFangTC-Semibold", "PingFangTC-Light", "PingFangTC-Ultralight"]]
------------------------------
Font Family Name = [Tamil Sangam MN]
Font Names = [["TamilSangamMN", "TamilSangamMN-Bold"]]
------------------------------
Font Family Name = [Khmer Sangam MN]
Font Names = [["KhmerSangamMN"]]
------------------------------
Font Family Name = [Crashlytics]
Font Names = [["Crashlytics"]]
------------------------------
Font Family Name = [Apple SD Gothic Neo]
Font Names = [["AppleSDGothicNeo-Thin", "AppleSDGothicNeo-Light", "AppleSDGothicNeo-Regular", "AppleSDGothicNeo-Bold", "AppleSDGothicNeo-SemiBold", "AppleSDGothicNeo-UltraLight", "AppleSDGothicNeo-Medium"]]
------------------------------
Font Family Name = [Gurmukhi MN]
Font Names = [["GurmukhiMN-Bold", "GurmukhiMN"]]
------------------------------
Font Family Name = [Arial Rounded MT Bold]
Font Names = [["ArialRoundedMTBold"]]
------------------------------
Font Family Name = [Al Nile]
Font Names = [["AlNile", "AlNile-Bold"]]
------------------------------
Font Family Name = [Bodoni 72 Smallcaps]
Font Names = [["BodoniSvtyTwoSCITCTT-Book"]]
------------------------------
Font Family Name = [Marker Felt]
Font Names = [["MarkerFelt-Thin", "MarkerFelt-Wide"]]
------------------------------
Font Family Name = [Kannada Sangam MN]
Font Names = [["KannadaSangamMN-Bold", "KannadaSangamMN"]]
------------------------------
Font Family Name = [Noto Sans Chakma]
Font Names = [["NotoSansChakma-Regular"]]
------------------------------
Font Family Name = [Menlo]
Font Names = [["Menlo-BoldItalic", "Menlo-Bold", "Menlo-Italic", "Menlo-Regular"]]
------------------------------
Font Family Name = [Avenir]
Font Names = [["Avenir-Oblique", "Avenir-HeavyOblique", "Avenir-Heavy", "Avenir-BlackOblique", "Avenir-BookOblique", "Avenir-Roman", "Avenir-Medium", "Avenir-Black", "Avenir-Light", "Avenir-MediumOblique", "Avenir-Book", "Avenir-LightOblique"]]
------------------------------
Font Family Name = [Telugu Sangam MN]
Font Names = [[]]
------------------------------
Font Family Name = [Gujarati Sangam MN]
Font Names = [["GujaratiSangamMN", "GujaratiSangamMN-Bold"]]
------------------------------
Font Family Name = [Roboto]
Font Names = [["Roboto-Regular", "Roboto-Light", "Roboto-LightItalic", "Roboto-Medium", "Roboto-Bold"]]
------------------------------
Font Family Name = [Bodoni 72 Oldstyle]
Font Names = [["BodoniSvtyTwoOSITCTT-BookIt", "BodoniSvtyTwoOSITCTT-Book", "BodoniSvtyTwoOSITCTT-Bold"]]
------------------------------
Font Family Name = [Myanmar Sangam MN]
Font Names = [["MyanmarSangamMN", "MyanmarSangamMN-Bold"]]
------------------------------
Font Family Name = [Kefa]
Font Names = [["Kefa-Regular"]]
------------------------------
Font Family Name = [Zapf Dingbats]
Font Names = [["ZapfDingbatsITC"]]
------------------------------
Font Family Name = [Zapfino]
Font Names = [["Zapfino"]]

 
 */
