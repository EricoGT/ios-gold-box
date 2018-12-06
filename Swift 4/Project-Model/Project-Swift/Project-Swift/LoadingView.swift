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
import NVActivityIndicatorView

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • CLASS

final class LoadingView: UIView {
    
    //Ao utilizar o bloco de retorno desta forma não é necessário @escaping.
    typealias CompletionHandler = () -> ()
    
    //MARK: - • LOCAL DEFINES
    public enum ActivityIndicatorType: Int {
        case custom         = -1
        case waiting        = 0
        case loading        = 1
        case processing     = 2
        case downloading    = 3
        case sending        = 4
        case saving         = 5
        case updating       = 6
        case deleting       = 7
        case searching      = 8
        case synchronizing  = 9
        case sharing        = 10
        //
        func toString() -> String{
            switch self {
            case .custom:
                return  ""
            case .waiting:
                return NSLocalizedString("ACTIVITY_INDICATOR_TYPE_WAITING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .loading:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_LOADING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .processing:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_PROCESSING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .downloading:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_DOWNLOADING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .sending:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_SENDING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .saving:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_SAVING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .updating:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_UPDATING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .deleting:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_DELETING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .searching:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_SEARCHING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .synchronizing:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_SYNCHRONIZING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            case .sharing:
                return  NSLocalizedString("ACTIVITY_INDICATOR_TYPE_SHARING", tableName: "LoadingViewLocalizable", bundle: Bundle.main, value: "", comment: "")
            }
        }
    }
    
    //MARK: - • PUBLIC PROPERTIES
    public weak var controlDelegate:LoadingViewDelegate? = nil
    public weak var dataSourceDelegate:LoadingViewDataSource? = nil
    public var useBlurEffect:Bool = false
    public var useCancelButton:Bool = false
    public var useWaterMarkImage:Bool = false
    
    //MARK: - • PRIVATE PROPERTIES
    private let ANIMA_TIME:TimeInterval = 0.3
    private var isVisible:Bool = false;
    private var isCanceled:Bool = false;
    private var totalSecondsToHide:Int = 0;
    private var showProgressView:Bool = false;
    //
    @IBOutlet private var indicatorView:NVActivityIndicatorView!
    @IBOutlet private var imvBackground:UIImageView!
    @IBOutlet private var imvBlurEffectBackground:UIVisualEffectView!
    @IBOutlet private var imvCenter:UIImageView!
    @IBOutlet private var imvWaterMark:UIImageView!
    @IBOutlet private var lblTitle:UILabel!
    @IBOutlet private var lblAccessory:UILabel!
    @IBOutlet private var lblProgress:UILabel!
    @IBOutlet private var btnCancel:UIButton!
    @IBOutlet private var lblNote:UILabel!
    @IBOutlet private var viewProgress:UIProgressView!
    //
    
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
        
        let lv:LoadingView = UINib(nibName: String(describing: LoadingView.self), bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! LoadingView
        //lv.translatesAutoresizingMaskIntoConstraints = true
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
    
    public func startActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool, _ cDelegate:LoadingViewDelegate?, _ dsDelegate:LoadingViewDataSource?){
        
        self.startAutoHideActivity(type, showIndicatorInStatusBar, 0, cDelegate, dsDelegate)
    }
    
    public func startAutoHideActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool, _ secondsToHide:Int, _ cDelegate:LoadingViewDelegate?, _ dsDelegate:LoadingViewDataSource?){
        
        DispatchQueue.main.async {
            
            self.layoutIfNeeded()
            
            if (!self.isVisible){
                
                //Configurando o componente:
                self.isCanceled = false
                self.controlDelegate = cDelegate
                self.dataSourceDelegate = dsDelegate
                //
                self.lblProgress?.text = ""
                self.lblAccessory?.text = ""
                //
                if (type == .custom){
                    self.lblTitle?.text = self.dataSourceDelegate?.loadingViewStringForCustomType(lV: self)
                    //
                    if (self.useWaterMarkImage){
                        self.imvWaterMark?.image = self.dataSourceDelegate?.loadingViewImageWaterMarkForCustomType(lV: self)
                    }else{
                        self.imvWaterMark?.image = nil
                    }
                }else{
                    self.lblTitle?.text = type.toString()
                    //
                    if (self.useWaterMarkImage){
                        self.imvWaterMark?.image = self.waterMarkImageForType(type)
                    }else{
                        self.imvWaterMark?.image = nil
                    }
                }
                
                //Exibindo o componente:
                if (self.useCancelButton){
                    self.btnCancel?.alpha = 1.0
                }else{
                    self.btnCancel?.alpha = 0.0
                }
                //
                if (secondsToHide < 1){
                    self.indicatorView.alpha = 1.0
                    self.indicatorView.startAnimating()
                }else{
                    self.totalSecondsToHide = secondsToHide
                    //
                    self.lblProgress?.alpha = 1.0
                    //self.indicatorView.alpha = 0.0
                    //
                    //Criando o activity circular
                    let circularProgress:RPCircularProgress? = RPCircularProgress()
                    circularProgress?.thicknessRatio = 0.15
                    circularProgress?.trackTintColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0) // -> cinzinha sem vergonha!
                    circularProgress?.progressTintColor = ToolBox.Graphic.colorWithHexString(string: "#31B74D") //-> verdinho maroto!
                    circularProgress?.frame = CGRect.init(x: 0.0, y: 0.0, width: (self.lblProgress?.frame.size.width)!, height: (self.lblProgress?.frame.size.height)!)
                    //
                    self.lblProgress?.addSubview(circularProgress!)
                    //
                    //Timer loop:
                    self.tickProgress(self.totalSecondsToHide, circularProgress!)
                }
                
                //Indicador de atividade conexão internet:
                if (showIndicatorInStatusBar) {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                
                //Reinserindo o componente:
                App.Delegate.window?.bringSubviewToFront(self)
                self.isVisible = true
                //
                self.controlDelegate?.loadingViewWillShow(lV: self)
                
                //Animações:
                self.scaleAnimation(self)
                //
                if (self.useBlurEffect){
                    self.imvBackground?.alpha = 0.0
                    self.imvBlurEffectBackground?.isHidden = false
                    //
                    self.alpha = 1.0
                    self.controlDelegate?.loadingViewDidShow(lV: self)
                }else{
                    self.imvBackground?.alpha = 1.0
                    self.imvBlurEffectBackground?.isHidden = true
                    //
                    UIView.animate(withDuration: self.ANIMA_TIME, animations: {
                        self.alpha = 1.0
                    }, completion: { (finished) in
                        self.controlDelegate?.loadingViewDidShow(lV: self)
                    })
                }
            }
        }
    }
    
    public func updateAccessoryLabel(_ message:String){
        
        DispatchQueue.main.async {
            self.lblAccessory?.text = message
        }
    }
    
    public func stopActivity(_ completionHandler:CompletionHandler?){
        
        DispatchQueue.main.async {
            
            self.controlDelegate?.loadingViewWillHide(lV: self)
            
            //Animações:
            self.scaleAnimation(self)
            //
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if (self.useBlurEffect){
                    self.alpha = 0.0
                    self.isVisible = false;
                    self.lblTitle?.text = ""
                    self.lblAccessory?.text = ""
                    self.totalSecondsToHide = 0
                    self.indicatorView.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.controlDelegate?.loadingViewDidHide(lV: self)
                    //
                    completionHandler?()
                }else{
                    
                    UIView.animate(withDuration: self.ANIMA_TIME, animations: {
                        self.alpha = 0.0
                    }, completion: { (finished) in
                        
                        self.isVisible = false;
                        //
                        self.controlDelegate?.loadingViewDidHide(lV: self)
                        //
                        completionHandler?()
                        //
                        DispatchQueue.main.async {
                            self.lblTitle?.text = ""
                            self.lblAccessory?.text = ""
                            self.totalSecondsToHide = 0
                            //
                            self.indicatorView.stopAnimating()
                            //
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    })
                }
            }
        }
    }
    
    public func stopActivity(title:String?, message:String?, timeToHide:Double, completionHandler:CompletionHandler?){
        
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
                
                self.stopActivity(completionHandler)
            })
        }
    }
    
    public func setProgressViewVisible(visible:Bool){
        
        showProgressView = visible;
        DispatchQueue.main.async {
            self.viewProgress.alpha = self.showProgressView ? 1.0 : 0.0;
        }
    }
    
    public func updateProgressView(progress:Float){
        
        if (showProgressView) {
            DispatchQueue.main.async {
                self.viewProgress.progress = progress 
            }
        }
    }
    
    public func updateNoteLabel(_ message:String){
        
        DispatchQueue.main.async {
            self.lblNote?.alpha = 1.0
            self.lblNote?.text = message
        }
    }
    
    public func updateLabels(_ accessorymMessage:String, _ noteMessage:String){
        
        DispatchQueue.main.async {
            self.lblAccessory?.alpha = 1.0
            self.lblAccessory?.text = accessorymMessage
            //
            self.lblNote?.alpha = 1.0
            self.lblNote?.text = noteMessage
        }
    }
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionCancel(sender:AnyObject){
        
        isCanceled = true;
        //
        self.stopActivity(nil)
        //
        controlDelegate?.loadingViewCanceled(lV: self)
    }
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    private func setupLayout(){
        
        self.frame = (App.Delegate.window?.frame)!
        //
        self.backgroundColor = UIColor.clear
        //
        self.lblTitle?.backgroundColor = UIColor.clear
        self.lblTitle?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_LABEL_NORMAL)
        self.lblTitle?.textColor = App.Style.colorView_SuperDark
        //
        self.lblAccessory?.backgroundColor = UIColor.clear
        self.lblAccessory?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        self.lblAccessory?.textColor = App.Style.colorView_Dark
        //
        self.lblProgress?.backgroundColor = UIColor.clear
        self.lblProgress?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_SEMIBOLD, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        self.lblProgress?.textColor = App.Style.colorView_SuperDark
        //
        self.lblNote?.backgroundColor = UIColor.clear
        self.lblNote?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_REGULAR, size: App.Constants.FONT_SIZE_LABEL_MINI)
        self.lblNote?.textColor = App.Style.colorView_Dark
        self.lblNote?.alpha = 0.0
        //
        self.viewProgress.backgroundColor = UIColor.clear
        self.viewProgress.trackTintColor = App.Style.colorView_Light
        self.viewProgress.progressTintColor = UIColor.blue
        self.viewProgress?.alpha = 0.0
        //
        self.imvBackground?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        self.imvBackground?.alpha = 1.0
        //
        self.imvBlurEffectBackground?.backgroundColor = UIColor.clear
        self.imvBlurEffectBackground?.isHidden = false
        //
        self.imvCenter?.backgroundColor = UIColor.clear
        self.imvCenter?.image = ToolBox.Graphic.createFlatImage(size: (imvCenter?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.white)
        ToolBox.Graphic.applyShadow(view: self.imvCenter!, color: UIColor.black, offSet: CGSize.init(width: 2.0, height: 2.0), radius: 2.0, opacity: 0.5)
        //
        self.btnCancel?.backgroundColor = UIColor.clear
        self.btnCancel?.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: (btnCancel?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.white), for: UIControl.State.normal)
        self.btnCancel?.setBackgroundImage(ToolBox.Graphic.createFlatImage(size: (btnCancel?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.lightGray), for: UIControl.State.highlighted)
        self.btnCancel?.setTitleColor(App.Style.colorText_RedDark, for: UIControl.State.normal)
        self.btnCancel?.titleLabel?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_REGULAR, size: App.Constants.FONT_SIZE_BUTTON_TITLE)
        ToolBox.Graphic.applyShadow(view: self.btnCancel!, color: UIColor.black, offSet: CGSize.init(width: 2.0, height: 2.0), radius: 2.0, opacity: 0.5)
        //
        self.tag = 666
        //
        self.indicatorView.type = .ballSpinFadeLoader
        self.indicatorView.color = App.Style.colorView_RedDefault
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
        progress.updateProgress(1.0 - (CGFloat(Double(currentTime)/Double(totalSecondsToHide))), animated: true, initialDelay: 0.0, duration: 1.0) {
            
            if (!self.isCanceled){
                if (currentTime > 0){
                    currentTime -= 1
                    self.tickProgress(currentTime, progress)
                }else{
                    progress.removeFromSuperview()
                    self.lblProgress?.alpha = 0.0
                    //
                    self.stopActivity(nil)
                }
            }
        }
    }
    
    private func scaleAnimation(_ view:UIView){
        
        let scaleAnima:CABasicAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnima.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        scaleAnima.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1))
        scaleAnima.duration = 0.1
        scaleAnima.autoreverses = true
        scaleAnima.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnima.isRemovedOnCompletion = true
        //
        view.layer.add(scaleAnima, forKey: "ScaleAnimation")
    }
    
    private func waterMarkImageForType(_ type:ActivityIndicatorType) -> UIImage?{
        
        switch type {
        case .custom:
            return  nil
        case .waiting:
            return UIImage.init(named: "loadingview_watermark_waiting")
        case .loading:
            return UIImage.init(named: "loadingview_watermark_loading")
        case .processing:
            return UIImage.init(named: "loadingview_watermark_processing")
        case .downloading:
            return UIImage.init(named: "loadingview_watermark_downloading")
        case .sending:
            return UIImage.init(named: "loadingview_watermark_sending")
        case .saving:
            return UIImage.init(named: "loadingview_watermark_saving")
        case .updating:
            return UIImage.init(named: "loadingview_watermark_updating")
        case .deleting:
            return UIImage.init(named: "loadingview_watermark_deleting")
        case .searching:
            return UIImage.init(named: "loadingview_watermark_searching")
        case .synchronizing:
            return UIImage.init(named: "loadingview_watermark_synchronizing")
        case .sharing:
            return UIImage.init(named: "loadingview_watermark_sharing")
        }
    }
    
}

//MARK:
protocol LoadingViewDelegate:NSObjectProtocol
{
    func loadingViewWillShow(lV:LoadingView)
    func loadingViewDidShow(lV:LoadingView)
    //
    func loadingViewWillHide(lV:LoadingView)
    func loadingViewDidHide(lV:LoadingView)
    //
    func loadingViewCanceled(lV:LoadingView)
}

protocol LoadingViewDataSource:NSObjectProtocol
{
    func loadingViewStringForCustomType(lV:LoadingView) -> String
    func loadingViewImageWaterMarkForCustomType(lV:LoadingView) -> UIImage
}
