//
//  SideMenuVC.swift
//  Project-Swift
//
//  Created by Erico GT on 22/06/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • ENUMS

public enum SideMenuType: Int {
    case normal             = 1
    case professional       = 2
    case custom             = 3
}

public enum SideMenuOptionState: Int {
    case simple             = 0
    case compressed         = 1
    case expanded           = 2
}

public enum SideMenuDestinationType: Int {
    case home               = 0
    case screen_1           = 1
    case screen_2           = 2
    case screen_3           = 3
    case screen_4           = 4
}

//MARK: - AUX CLASSES

public class SideMenuOption:NSObject
{
    public var level:Int
    public var groupIdentifier:String?
    public var optionTitle:String
    public var state:SideMenuOptionState
    public var blocked:Bool
    public var subItems:[SideMenuOption]?
    public var destinationType:SideMenuDestinationType
    public var badgeCount:Int
    
    override init(){
        
        level = 0
        groupIdentifier = nil
        optionTitle = ""
        state = .simple
        blocked = false
        subItems = nil
        destinationType = .home
        badgeCount = 0
    }
    
    public func new(l:Int, gi:String?, ot:String, s:SideMenuOptionState, b:Bool, si:[SideMenuOption]?, dt:SideMenuDestinationType, bc:Int) -> SideMenuOption!{
        
        let newOption:SideMenuOption = SideMenuOption.init()
        //
        newOption.level = l
        newOption.groupIdentifier = gi
        newOption.optionTitle = ot
        newOption.state = s
        newOption.blocked = b
        newOption.subItems = si
        newOption.destinationType = dt
        newOption.badgeCount = bc
        //
        return newOption
    }
    
}

public class SideMenuOptionTVC:UITableViewCell
{
    @IBOutlet var lblItem:UILabel!
    @IBOutlet var imvItemSelected:UIImageView!
    @IBOutlet var lblBadge:UILabel!
    @IBOutlet var leftPadConstraint:NSLayoutConstraint!
    
    public func setupLayoutForLevel(_ level:Int){
        
        self.backgroundColor = UIColor.clear
        //
        self.lblItem.backgroundColor = UIColor.clear
        self.lblItem.textColor = UIColor.gray
        //
        self.lblBadge.backgroundColor = UIColor.red
        self.lblBadge.textColor = UIColor.white
        self.lblBadge.layer.cornerRadius = self.lblBadge.frame.size.height / 2.0
        self.lblBadge.layer.masksToBounds = true
        //
        self.imvItemSelected.backgroundColor = UIColor.clear
        //
        let pad:CGFloat = CGFloat(32.0 + (Double(level) * 30.0))
        self.leftPadConstraint.constant = pad > 92.0 ? 92.0 : pad
        //
        self.layoutIfNeeded()
    }
}

//MARK: - PROTOCOLS

public protocol SideMenuDelegate:NSObjectProtocol
{
    func sideMenuOptionSelected(destinationType:SideMenuDestinationType, menuType:SideMenuType)
    func sideMenuLoadData() -> Array<SideMenuOption>
    //
    func sideMenuTextForTitle() -> String?
    func sideMenuTextForSubTitle() -> String?
    func sideMenuTextForDescription() -> String?
    func sideMenuImageForAvatar() -> UIImage?
    func sideMenuImageForHeaderBackground() -> UIImage?
}

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    
    
    //MARK: - • PRIVATE PROPERTIES
    
    //Data:
    private weak var menuDelegate:SideMenuDelegate? = nil
    //
    private var optionsList:[SideMenuOption]?
    private var filteredList:[SideMenuOption]?
    private var isTouchResolved:Bool
    private var menuType:SideMenuType
    private var groupSelected:String?
    
    //Layout:
    @IBOutlet private var btnClose:UIButton!
    //
    @IBOutlet private var viewMenu:UIView!
    @IBOutlet private var lblTitle:UILabel!
    @IBOutlet private var lblSubTitle:UILabel!
    @IBOutlet private var lblDescription:UILabel!
    @IBOutlet private var imvAvatar:UIImageView!
    @IBOutlet private var imvHeaderBackground:UIImageView!
    @IBOutlet private var imvHeaderLine:UIImageView!
    @IBOutlet private var tvMenu:UITableView!
    //
    @IBOutlet private var viewFooter:UIView!
    @IBOutlet private var lblDevelopedBy:UILabel!
    @IBOutlet private var lblAppVersion:UILabel!
    @IBOutlet private var imvLogo:UIImageView!
    @IBOutlet private var imvFooterLine:UIImageView!
    
    //MARK: - • INITIALISERS
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        self.optionsList = nil
        self.filteredList = nil
        self.isTouchResolved = true
        self.groupSelected = nil
        self.menuType = .normal
        //
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.optionsList = nil
        self.filteredList = nil
        self.isTouchResolved = true
        self.groupSelected = nil
        self.menuType = .normal
        //
        super.init(coder: aDecoder)
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    //UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (isTouchResolved)
        {
            isTouchResolved = false
            
            let cell:SideMenuOptionTVC = tableView.cellForRow(at: indexPath) as! SideMenuOptionTVC
            
            //UI - Animação de seleção:
            DispatchQueue.main.async {
                cell.backgroundColor = UIColor.gray
                //
                UIView.animate(withDuration: App.Constants.ANIMA_TIME_FAST, delay: 0.0, options: .curveLinear, animations: {
                    cell.backgroundColor = UIColor.clear
                }, completion: nil)
            }
            
            //Som:
            App.Delegate.soundPlayer.play(sound: .DumEffect, volume: 1.0)
            
            //Resolução de seleção:
            let option:SideMenuOption = filteredList![indexPath.row]
            
            let subItemsMax:Int = ToolBox.isNil(option.subItems) ? 0 : option.subItems!.count
            
            if (option.blocked || subItemsMax == 0 || option.state == .simple) {
                DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.ANIMA_TIME_SUPER_FAST, execute: {
                    self.selectionResolver(destinationType: option.destinationType)
                })
                
            }else if(option.state == .compressed){
                
                var indexPathList:Array<IndexPath> = Array.init()
                //
                for i in 0..<subItemsMax {
                    self.filteredList?.insert(option.subItems![i], at: (indexPath.row + (i + 1)))
                    indexPathList.append(IndexPath.init(row: (indexPath.row + (i + 1)), section: 0))
                }
                //
                option.state = .expanded
                //
                self.tvMenu.beginUpdates()
                self.tvMenu.insertRows(at: indexPathList, with: .fade)
                self.tvMenu.endUpdates()
            }else{
                
                var indexPathList:Array<IndexPath> = Array.init()
                //
                for i in 0..<subItemsMax {
                    self.filteredList?.remove(at: indexPath.row + 1)
                    indexPathList.append(IndexPath.init(row: (indexPath.row + (i + 1)), section: 0))
                }
                //
                option.state = .compressed
                //
                self.tvMenu.beginUpdates()
                self.tvMenu.deleteRows(at: indexPathList, with: .fade)
                self.tvMenu.endUpdates()
            }
            
            self.isTouchResolved = true
        }
        
    }
    
    //UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:SideMenuOptionTVC? = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionTVC") as? SideMenuOptionTVC
        
        if (ToolBox.isNil(cell)) {
            cell = SideMenuOptionTVC.init(style: .default, reuseIdentifier: "SideMenuOptionTVC")
        }
        
        let option:SideMenuOption = self.filteredList![indexPath.row]
        
        cell?.setupLayoutForLevel(option.level)
        
        cell?.lblItem.text = option.optionTitle
        
        if (option.badgeCount == 0){
            cell?.lblBadge.alpha = 0.0
        }else{
            cell?.lblBadge.text = String.init(option.badgeCount)
            cell?.lblBadge.alpha = 1.0
        }
    
        cell?.lblItem.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: 16.0)
        cell?.imvItemSelected.backgroundColor = UIColor.clear
        
        if (option.groupIdentifier == self.groupSelected){
            cell?.lblItem.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: 17.0)
            if (option.level == 0){
                cell?.imvItemSelected.backgroundColor = UIColor.gray
            }
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToolBox.isNil(self.filteredList) ? 0 : self.filteredList!.count
    }
    
    //MARK: - • PUBLIC METHODS
    
    public func show(type:SideMenuType, delegate:SideMenuDelegate?, actualGroup:String?){
        
        self.groupSelected = actualGroup
        
        if let del:SideMenuDelegate = delegate{
            
            self.menuDelegate = del
            
            self.lblTitle.text = del.sideMenuTextForTitle()
            self.lblSubTitle.text = del.sideMenuTextForSubTitle()
            self.lblDescription.text = del.sideMenuTextForDescription()
            //
            self.imvAvatar.image = del.sideMenuImageForAvatar()
            self.imvHeaderBackground.image = del.sideMenuImageForHeaderBackground()
        }
        
        self.optionsList = self.loadItemsForType(type)
        //self.filteredList = self.optionsList
        self.filteredList = Array.init()
        
        //Arruma a lista filtrada para itens expandidos:
        
        if (!ToolBox.isNil(self.optionsList)) {
            
            for i in 0..<self.optionsList!.count {
                
                let optE = self.optionsList![i]
                
                self.filteredList?.append(optE)
                
                if (!ToolBox.isNil(optE.subItems)) {
                    
                    if optE.state == .expanded {
                        
                        for j in 0..<optE.subItems!.count {
                            
                            let optI = optE.subItems![j]
                            self.filteredList?.append(optI)
                        }
                    }
                }
            }
        }
        
        self.tvMenu.reloadData()
        self.tvMenu.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        
        self.btnClose.alpha = 0.0
        self.viewMenu.frame = CGRect.init(x: -self.viewMenu.frame.size.width, y: 0.0, width: self.viewMenu.frame.size.width, height: self.viewMenu.frame.size.height)
        //
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { 
            self.btnClose.alpha = 0.5
            self.viewMenu.frame = CGRect.init(x: 0.0, y: 0.0, width: self.viewMenu.frame.size.width, height: self.viewMenu.frame.size.height)
        }, completion: nil)
        
    }
    
    public func setAppVersion(text:String!){
        self.lblAppVersion.text = text
    }
    
    public func setDevelopedBy(text:String!){
        self.lblDevelopedBy.text = text
    }
    
    public func setLogo(image:UIImage!){
        self.imvLogo.image = image
    }
    
    //MARK: - • ACTION METHODS
    
    @IBAction public func hide(sender:Any?){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.btnClose.alpha = 0.0
            self.viewMenu.frame = CGRect.init(x: -self.viewMenu.frame.size.width, y: 0.0, width: self.viewMenu.frame.size.width, height: self.viewMenu.frame.size.height)
        }, completion: { (finished) in
            self.view.removeFromSuperview()
        })
    }
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout(){
        
        self.view.backgroundColor = UIColor.clear
        //
        self.btnClose.backgroundColor = UIColor.black
        self.btnClose.alpha = 0.0 //Vai para 0.5 na animação de exibição
        //
        self.viewMenu.backgroundColor = UIColor.white
        self.tvMenu.backgroundColor = UIColor.clear
        //
        self.lblTitle.backgroundColor = UIColor.clear
        self.lblTitle.textColor = UIColor.gray
        self.lblTitle.text = ""
        self.lblTitle.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: 26.0)
        //
        self.lblSubTitle.backgroundColor = UIColor.clear
        self.lblSubTitle.textColor = UIColor.gray
        self.lblSubTitle.text = ""
        self.lblSubTitle.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: 14.0)
        //
        self.lblDescription.backgroundColor = UIColor.clear
        self.lblDescription.textColor = UIColor.gray
        self.lblDescription.text = ""
        self.lblDescription.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: 14.0)
        //
        self.imvAvatar.backgroundColor = UIColor.clear
        self.imvAvatar.image = nil
        self.imvHeaderBackground.backgroundColor = UIColor.clear
        self.imvHeaderBackground.image = nil
        //
        self.imvAvatar.backgroundColor = UIColor.clear
        self.imvAvatar.image = nil
        //
        self.imvHeaderBackground.backgroundColor = UIColor.clear
        self.imvHeaderBackground.image = nil
        //
        self.imvHeaderLine.backgroundColor = UIColor.clear
        self.imvHeaderLine.image = UIImage.init(named: "line-separator-side-menu")!.withRenderingMode(.alwaysTemplate)
        self.imvHeaderLine.tintColor = UIColor.gray
        //
        self.viewFooter.backgroundColor = UIColor.white
        self.lblDevelopedBy.backgroundColor = UIColor.white
        self.lblDevelopedBy.textColor = UIColor.gray
        self.lblDevelopedBy.text = "Desenvolvido por: "
        self.lblDevelopedBy.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: 12.0)
        //
        self.lblAppVersion.backgroundColor = UIColor.white
        self.lblAppVersion.textColor = UIColor.gray
        self.lblAppVersion.text = "Versão App: " + ToolBox.applicationHelper_VersionBundle()
        self.lblAppVersion.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_MEDIUM, size: 12.0)
        //
        self.imvLogo.backgroundColor = UIColor.clear
        self.imvLogo.image = UIImage.init(named: "guardachuva.jpeg")
        self.imvFooterLine.image = UIImage.init(named: "line-separator-side-menu")!.withRenderingMode(.alwaysTemplate)
        self.imvFooterLine.tintColor = UIColor.gray
        
        //Data:
        tvMenu.reloadData()
        
        //Shadow
        ToolBox.graphicHelper_ApplyShadow(view: viewMenu, color: UIColor.black, offSet: CGSize.init(width: 3.0, height: 0.0), radius: 5.0, opacity: 0.5)
    }
    
    public func loadItemsForType(_ t:SideMenuType) -> [SideMenuOption]!{
        
        self.menuType = t;
        
        if (ToolBox.isNil(self.menuDelegate)){
            
            var list:Array<SideMenuOption> = Array.init()
            
            switch t {
            case .normal:
                
                let option1:SideMenuOption = SideMenuOption.init()
                option1.level = 0
                option1.groupIdentifier = "OPT_1"
                option1.optionTitle = "Opção 1"
                option1.state = .simple
                option1.blocked = false
                option1.subItems = nil
                option1.destinationType = .home
                option1.badgeCount = 0
                //
                let option2:SideMenuOption = SideMenuOption.init()
                option2.level = 0
                option2.groupIdentifier = "OPT_2"
                option2.optionTitle = "Opção 2"
                option2.state = .simple
                option2.blocked = false
                option2.subItems = nil
                option2.destinationType = .home
                option2.badgeCount = 0
                //
                let option3:SideMenuOption = SideMenuOption.init()
                option3.level = 0
                option3.groupIdentifier = "OPT_3"
                option3.optionTitle = "Opção 3"
                option3.state = .simple
                option3.blocked = false
                option3.subItems = nil
                option3.destinationType = .home
                option3.badgeCount = 0
                //
                list.append(option1)
                list.append(option2)
                list.append(option3)
                
                break
                
            case .professional:
                
                break
                
                
            case .custom:
                
                break
            }
            
            return list
            
        }else{
            return self.menuDelegate?.sideMenuLoadData()
        }
    }
    
    public  func selectionResolver(destinationType:SideMenuDestinationType){
        
        if (!ToolBox.isNil(self.menuDelegate)){
            self.menuDelegate?.sideMenuOptionSelected(destinationType: destinationType, menuType:self.menuType)
        }
        
        self.isTouchResolved = true
        
//        switch destinationType {
//        case .home:
//            break
//        case .screen_1:
//            break
//        case .screen_2:
//            break
//        case .screen_3:
//            break
//        case .screen_4:
//            break
//        }
    }
    
    
}




