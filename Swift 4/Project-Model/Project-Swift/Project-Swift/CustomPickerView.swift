//
//  CustomPickerView.swift
//  Etna
//
//  Created by Erico GT on 22/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • CLASS

final class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //MARK: - • LOCAL DEFINES
    
    //MARK: - • PUBLIC PROPERTIES
    weak var controlDelegate:CustomPickerViewDelegate?
    weak var dataSourceDelegate:CustomPickerViewDataSource?
    //
    var arrayOfItems:Array<OptionItem>?
    var selectedIndex:Int!
    var isVisible:Bool!
    
    //MARK: - • PRIVATE PROPERTIES
    @IBOutlet private weak var accessoryView:UIView!
    @IBOutlet private weak var btnConfirm:UIButton!
    @IBOutlet private weak var btnClear:UIButton!
    @IBOutlet private weak var pkrView:UIPickerView!
    //
    private var senderForReference:Any?
    
    
    //MARK: - • INITIALISERS
    
    //storyboard initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //programmatic initializer
    init() {
        super.init(frame: CGRect())
    }
    
    class func new(owner:Any) -> CustomPickerView{
        
        let cpv:CustomPickerView = UINib(nibName: String(describing: CustomPickerView.self), bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! CustomPickerView
        //
        cpv.layoutIfNeeded()
        cpv.setupLayout()
        //
        return cpv
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    //PickerView Delegate:
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (view != nil){
            
            let label:UILabel = view as! UILabel
            label.text = arrayOfItems?[row].title
            return label
            
        }else{
            
            let label:UILabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: pickerView.frame.size.width, height: 44.0))
            label.backgroundColor = UIColor.clear
            label.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: App.Constants.FONT_SIZE_LABEL_BIG)
            label.textColor = App.Style.colorText_GrayDark
            label.textAlignment = .center
            //
            label.text = arrayOfItems?[row].title
            //
            return label;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let array = arrayOfItems{
            return array.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44.0
    }
    
    //MARK: - • PUBLIC METHODS
    func show(sender:Any?, rowSelected:Int, animated:Bool) {
        
        senderForReference = sender
        
        if (dataSourceDelegate != nil){
            arrayOfItems = self.dataSourceDelegate?.customPickerViewLoadData(picker: self, sender: sender)
        }
        pkrView.reloadAllComponents()
        
        if let array = arrayOfItems {
            
            if (rowSelected < 0){
                selectedIndex = 0;
            }else if(rowSelected > (array.count - 1)){
                selectedIndex = (array.count - 1);
            }else{
                selectedIndex = rowSelected;
            }
            //
            pkrView.selectRow(selectedIndex, inComponent: 0, animated: animated)
        }
        
        if !isVisible {
            
            isVisible = true
            
            self.frame = CGRect.init(x: 0.0, y: self.superview!.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
            self.superview?.bringSubviewToFront(self)
            
            if (animated){
                UIView.animate(withDuration: App.Constants.ANIMA_TIME_FAST, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut], animations: { 
                    self.frame = CGRect.init(x: 0.0, y: self.superview!.frame.size.height - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
                    self.alpha = 1.0
                }, completion: nil)
            }else{
                self.frame = CGRect.init(x: 0.0, y: self.superview!.frame.size.height - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
                self.alpha = 1.0
            }
        }
    }
    
    func hide(animated:Bool) {
        
        if (isVisible) {
            
            if (animated) {
                UIView.animate(withDuration: App.Constants.ANIMA_TIME_FAST, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                    self.frame = CGRect.init(x: 0.0, y: self.superview!.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
                    self.alpha = 0.0
                }, completion: { (finished) in
                    self.alpha = 0.0
                    self.isVisible = false
                })
            }
        }
    }
    
    //MARK: - • ACTION METHODS
    
    @IBAction private func hideAction(_ sender:UIButton) {
    
        if (sender == btnClear) {
            selectedIndex = -1
        }
        
        if (selectedIndex == -1) {
            if (self.controlDelegate != nil) {
                self.controlDelegate?.customPickerViewDidClearItem(sender: senderForReference)
            }
        }else{
            if (self.controlDelegate != nil) {
                self.controlDelegate?.customPickerViewDidConfirmItem(item: (arrayOfItems?[selectedIndex])!, sender: senderForReference)
            }
        }
        
        self.hide(animated: true)
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout() {
        
        //data:
        selectedIndex = -1
        arrayOfItems = nil
        controlDelegate = nil
        dataSourceDelegate = nil
        //view:
        isVisible = false
        self.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 230)
        //
        self.backgroundColor = UIColor.white
        pkrView.backgroundColor = UIColor.clear
        accessoryView.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        //
        btnConfirm.backgroundColor = UIColor.clear
        btnClear.backgroundColor = UIColor.clear
        //
        btnConfirm.contentHorizontalAlignment = .right;
        btnConfirm.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 14.0)
        btnConfirm.setTitleColor(App.Style.colorText_BlueDefault, for: .normal)
        btnConfirm.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
        btnConfirm.setTitle(App.STR("BUTTON_TITLE_CUSTOMPICKERVIEW_SELECT"), for: .normal)
        //
        btnClear.contentHorizontalAlignment = .left;
        btnClear.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 14.0, bottom: 0.0, right: 0.0)
        btnClear.setTitleColor(App.Style.colorText_BlueDefault, for: .normal)
        btnClear.titleLabel?.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
        btnClear.setTitle(App.STR("BUTTON_TITLE_CUSTOMPICKERVIEW_CLOSE"), for: .normal)
        //
        self.alpha = 0.0
    }
   
    
}

//MARK: - DELEGATES
protocol CustomPickerViewDelegate:NSObjectProtocol
{
    func customPickerViewDidConfirmItem(item:OptionItem, sender:Any?)
    func customPickerViewDidClearItem(sender:Any?)
}

protocol CustomPickerViewDataSource:NSObjectProtocol
{
    func customPickerViewLoadData(picker:CustomPickerView, sender:Any?) -> Array<OptionItem>?
}

//MARK: - SUPPORT CLASSES

class OptionItem {

    var title:String
    var description:String
    var index:Int
    var value:Float
    
    init() {
        self.title = ""
        self.description = ""
        self.index = 0
        self.value = 0.0
    }
    
    class func newOptionItem(_ itemTitle:String, _ itemDescription:String, _ itemIndex:Int, _ itemValue:Float) -> OptionItem{
        
        let option:OptionItem = OptionItem.init()
        option.title = itemTitle
        option.description = itemDescription
        option.index = itemIndex
        option.value = itemValue
        //
        return option
    }


}
