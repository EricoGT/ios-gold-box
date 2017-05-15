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

//MARK: - • CLASS

final class LoadingView: UIView {
    
    //MARK: - • LOCAL DEFINES
    public enum ActivityIndicatorType {
        case loading
        case processing
        case downloading
        case sending
        case saving
    }

    //MARK: - • PUBLIC PROPERTIES
    public weak var delegate:LoadingViewDelegate? = nil
    public var useBlurEffect:Bool = false
    public var useCancelButton:Bool = false
    
    //MARK: - • PRIVATE PROPERTIES
    private let ANIMA_TIME:TimeInterval = 0.3
    private var isVisible:Bool = false;
    private var isCanceled:Bool = false;
    private var totalSecondsToHide:Int = 0;
    //
    @IBOutlet private var activityIndicator:UIActivityIndicatorView?
    @IBOutlet private var imvBackground:UIImageView?
    @IBOutlet private var imvBlurEffectBackground:UIVisualEffectView?
    @IBOutlet private var imvCenter:UIImageView?
    @IBOutlet private var lblTitle:UILabel?
    @IBOutlet private var lblAccessory:UILabel?
    @IBOutlet private var lblProgress:UILabel?
    @IBOutlet private var btnCancel:UIButton?
    
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
    
    public func startActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool, _ delegate:LoadingViewDelegate?){
        
        self.layoutIfNeeded()
        self.startAutoHideActivity(type, showIndicatorInStatusBar, 0, delegate)
    }
    
    public func startAutoHideActivity(_ type:ActivityIndicatorType, _ showIndicatorInStatusBar:Bool, _ secondsToHide:Int, _ delegate:LoadingViewDelegate?){
        
        if (!isVisible){
            
            //Configurando o componente:
            isCanceled = false
            self.delegate = delegate
            //
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
            case .saving:
                lblTitle?.text = "Salvando..."
            }
            
            //Exibindo o componente:
            if (useCancelButton){
                btnCancel?.alpha = 1.0
            }else{
                btnCancel?.alpha = 0.0
            }
            //
            if (secondsToHide < 1){
                activityIndicator?.alpha = 1.0;
                activityIndicator?.startAnimating()
            }else{
                totalSecondsToHide = secondsToHide
                //
                lblProgress?.alpha = 1.0
                activityIndicator?.alpha = 0.0
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
                //Timer loop:
                self.tickProgress(totalSecondsToHide, circularProgress!)
            }
            
            //Indicador de atividade conexão internet:
            if (showIndicatorInStatusBar) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            //Reinserindo o componente:
            App.Delegate.window?.bringSubview(toFront: self)
            isVisible = true
            //
            self.delegate?.loadingViewWillShow(lV: self)
            
            //Animações:
            self.scaleAnimation(self)
            //
            if (useBlurEffect){
                imvBackground?.alpha = 0.0
                imvBlurEffectBackground?.alpha = 1.0
                //
                self.alpha = 1.0
                self.delegate?.loadingViewDidShow(lV: self)
            }else{
                imvBackground?.alpha = 1.0
                imvBlurEffectBackground?.alpha = 0.0
                //
                UIView.animate(withDuration: ANIMA_TIME, animations: {
                    self.alpha = 1.0
                }, completion: { (finished) in
                    self.delegate?.loadingViewDidShow(lV: self)
                })
            }
        }
    }
    
    public func updateAccessoryLabel(_ message:String){
        
        DispatchQueue.main.async {
            self.lblAccessory?.text = message
        }
    }
    
    public func stopActivity(){
        
        self.delegate?.loadingViewWillHide(lV: self)
        
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
                self.activityIndicator?.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.delegate?.loadingViewDidHide(lV: self)
            }else{
                
                UIView.animate(withDuration: self.ANIMA_TIME, animations: {
                    self.alpha = 0.0
                }, completion: { (finished) in
                    
                    self.isVisible = false;
                    //
                    self.delegate?.loadingViewDidHide(lV: self)
                    //
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
        }
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
    
    //MARK: - • ACTION METHODS
    
    @IBAction func actionCancel(sender:AnyObject){
        
        isCanceled = true;
        //lblProgress?.alpha = 0.0
        //
        delegate?.loadingViewCanceled(lV: self)
    }
    
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
        self.imvBackground?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        self.imvBackground?.alpha = 1.0
        //
        self.imvBlurEffectBackground?.backgroundColor = UIColor.clear
        self.imvBlurEffectBackground?.alpha = 1.0
        //
        self.imvCenter?.backgroundColor = UIColor.clear
        self.imvCenter?.image = ToolBox.graphicHelper_CreateFlatImage(size: (imvCenter?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.white)
        ToolBox.graphicHelper_ApplyShadow(view: self.imvCenter!, color: UIColor.black, offSet: CGSize.init(width: 2.0, height: 2.0), radius: 2.0, opacity: 0.5)
        //
        self.btnCancel?.backgroundColor = UIColor.clear
        self.btnCancel?.setBackgroundImage(ToolBox.graphicHelper_CreateFlatImage(size: (btnCancel?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.white), for: UIControlState.normal)
        self.btnCancel?.setBackgroundImage(ToolBox.graphicHelper_CreateFlatImage(size: (btnCancel?.frame.size)!, corners: UIRectCorner.allCorners, cornerRadius: CGSize.init(width: 6.0, height: 6.0), color: UIColor.lightGray), for: UIControlState.highlighted)
        self.btnCancel?.setTitleColor(App.Style.colorTextLabel_Other, for: UIControlState.normal)
        self.btnCancel?.titleLabel?.font = UIFont.init(name: App.Constants.FONT_MYRIAD_PRO_REGULAR, size: App.Constants.FONT_SIZE_LABEL)
        ToolBox.graphicHelper_ApplyShadow(view: self.btnCancel!, color: UIColor.black, offSet: CGSize.init(width: 2.0, height: 2.0), radius: 2.0, opacity: 0.5)
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
        progress.updateProgress(1.0 - (CGFloat(Double(currentTime)/Double(totalSecondsToHide))), animated: true, initialDelay: 0.0, duration: 1.0) {
            
            if (!self.isCanceled){
                if (currentTime > 0){
                    currentTime -= 1
                    self.tickProgress(currentTime, progress)
                }else{
                    progress.removeFromSuperview()
                    self.lblProgress?.alpha = 0.0
                    //
                    self.stopActivity()
                }
            }
        }
    }
    
    private func scaleAnimation(_ view:UIView){
        
        let scaleAnima:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnima.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        scaleAnima.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.05, 1.05, 1))
        scaleAnima.duration = 0.1
        scaleAnima.autoreverses = true
        scaleAnima.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        scaleAnima.isRemovedOnCompletion = true
        //
        view.layer.add(scaleAnima, forKey: "ScaleAnimation")
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
