//
//  LoadingView.swift
//  Project-Swift
//
//  Created by Erico GT on 11/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//extension UIView {
//
//    @discardableResult
//    func fromNib<T : UIView>() -> T? {
//        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
//            return nil
//        }
//        self.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        //view.layoutAttachAll(to: self)
//        return view
//    }
//}

//MARK: - • CLASS

final class LoadingView: UIView {
    
    //MARK: - • LOCAL DEFINES
    public enum ActivityIndicatorType {
        case loading
        case processing
        case downloading
        case sending
    }
    
    private let ANIMA_TIME:TimeInterval = 0.3
    private var isVisible:Bool = false;
    private var totalSecondsToHide:Int = 0;
    
    //MARK: - • PUBLIC PROPERTIES
    public func startActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool){
        
        self.layoutIfNeeded()
        self.startAutoHideActivity(type, showIndicatorInStatusBar, 0)
    }
    
    public func startAutoHideActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool, _ secondsToHide:Int){
    
        if (!isVisible){
            
            lblProgress?.text = ""
            lblAccessory?.text = ""
            //
            switch type {
            case .loading:
                lblTitle?.text = "Carregando..."
            case .processing:
                lblTitle?.text = "Processando..."
            case .downloading:
                lblTitle?.text = "Transferindo..."
            case .sending:
                lblTitle?.text = "Enviando..."
            }
            //
            if (secondsToHide < 1){
                activityIndicator?.alpha = 1.0;
                activityIndicator?.startAnimating()
            }else{
                totalSecondsToHide = secondsToHide;
                //
                activityIndicator?.alpha = 0.0;
                //
                //Criando o activity circular
                let circularProgress:RPCircularProgress? = RPCircularProgress()
                circularProgress?.thicknessRatio = 0.15
                circularProgress?.trackTintColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0) // -> cinzinha sem vergonha!
                circularProgress?.progressTintColor = ToolBox.graphicHelper_ColorWithHexString(string: "#31B74D") //-> verdinho maroto!
                circularProgress?.frame = CGRect.init(x: 0.0, y: 0.0, width: (lblProgress?.frame.size.width)!, height: (lblProgress?.frame.size.height)!)
                //
                lblProgress?.addSubview(circularProgress!)
                //
                //Timer
                self.tickProgress(secondsToHide, circularProgress!)
            }
            //
            if (showIndicatorInStatusBar) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            //
            App.Delegate.window?.bringSubview(toFront: self)
            //
            isVisible = true
            UIView.animate(withDuration: ANIMA_TIME) {
                self.alpha = 1.0
            }
        }
    }
    
    public func updateAccessoryLabel(_ message:String){
        
        DispatchQueue.main.async {
            self.lblAccessory?.text = message
        }
    }
    
    public func stopActivity(){
    
        UIView.animate(withDuration: self.ANIMA_TIME, animations: {
            self.alpha = 0.0
        }, completion: { (finished) in
            
            self.isVisible = false;
            
            DispatchQueue.main.async {
                self.lblTitle?.text = ""
                self.lblAccessory?.text = ""
                self.totalSecondsToHide = 0
                //
                self.activityIndicator?.stopAnimating()
                //
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
    }
    
    public func stopActivity(title:String?, message:String?, timeToHide:Double){
        
        DispatchQueue.main.async {
            if (title != nil){
                self.lblTitle?.text = title
            }
            //
            if (message != nil){
                self.lblAccessory?.text = message
            }
            //
            DispatchQueue.main.asyncAfter(deadline: .now() + timeToHide, execute: {
                
                self.stopActivity()
            })
        }
    }
    
    //MARK: - • PRIVATE PROPERTIES
    @IBOutlet private var activityIndicator:UIActivityIndicatorView?
    @IBOutlet private var imvBackground:UIImageView?
    @IBOutlet private var imvCenter:UIImageView?
    @IBOutlet private var lblTitle:UILabel?
    @IBOutlet private var lblAccessory:UILabel?
    @IBOutlet private var lblProgress:UILabel?
    
    //MARK: - • INITIALISERS
    
    //storyboard initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //programmatic initializer
    init() {
        super.init(frame: CGRect())
    }
    
    class func new(owner:Any) -> LoadingView{
        
        let lv:LoadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! LoadingView
        //
        lv.layoutIfNeeded()
        lv.setupLayout()
        //
        return lv
        
    }
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout(){
        
        self.frame = (App.Delegate.window?.frame)!
        //
        self.backgroundColor = UIColor.clear
        //
        self.lblTitle?.backgroundColor = UIColor.clear
        self.lblTitle?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_LABEL)
        self.lblTitle?.textColor = App.Style.colorTextLabel_Dark
        //
        self.lblAccessory?.backgroundColor = UIColor.clear
        self.lblAccessory?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        self.lblAccessory?.textColor = App.Style.colorTextLabel_Light
        //
        self.lblProgress?.backgroundColor = UIColor.clear
        self.lblProgress?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        self.lblProgress?.textColor = App.Style.colorTextLabel_Dark
        //
        self.imvBackground?.backgroundColor = UIColor.black
        self.imvBackground?.alpha = 0.3
        //
        self.imvCenter?.backgroundColor = UIColor.clear
        self.imvCenter?.image = ToolBox.graphicHelper_CreateFlatImage(size: (imvCenter?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.white)
        ToolBox.graphicHelper_ApplyShadow(view: self.imvCenter!, color: UIColor.black, offSet: CGSize.init(width: 2.0, height: 2.0), radius: 2.0, opacity: 0.5)
        //
        self.activityIndicator?.color = App.Style.colorBackgroundScreen_Dark
        self.tag = 666
        //
        App.Delegate.window?.addSubview(self)
        self.alpha = 0.0
        //
        self.layoutIfNeeded()
    }
    
    private func tickProgress(_ time:Int, _ progress:RPCircularProgress){
        
        var currentTime:Int = time;
        //
        lblProgress?.alpha = 1.0;
        lblProgress?.text = "\(currentTime)"
        //
        progress.updateProgress((CGFloat(1.0 - Double(time)/Double(totalSecondsToHide))), animated: true, initialDelay: 0.0, duration: 1.0) {
            //
            currentTime -= 1
            //
            if (currentTime > -1){
                self.tickProgress(currentTime, progress)
            }else{
                progress.removeFromSuperview()
                //progress = nil
                //
                self.stopActivity()
            }
        }
    }
}
