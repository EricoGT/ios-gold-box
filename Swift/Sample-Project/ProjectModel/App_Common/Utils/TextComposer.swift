//
//  TextComposer.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 04/07/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

class TextComposer {
    
    //MARK: Style Names Define:
    static let normal:String = "normal"
    static let bold:String = "bold"
    static let italic:String = "italic"
    static let underline:String = "underline"
    static let link:String = "underline"
    static let strike:String = "strike"
    static let attachment:String = "attachment"
    //insert here more names...
    
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
    
    func register(style:Dictionary<NSAttributedString.Key,Any>, withName:String) -> Void {
        styleList[withName] = style
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
//        var attributes:[NSAttributedStringKey : Any] = [NSAttributedStringKey : Any]()
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
