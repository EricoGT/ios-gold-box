//
//  ASViewController.swift
//  Etna
//
//  Created by Erico GT on 31/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • CLASSES

public class PMViewController: UIViewController {
    
    //MARK: - • LOCAL DEFINES
    
    
    //MARK: - • PUBLIC PROPERTIES
    @IBOutlet public var scrollViewBackground:UIScrollView!
    //
    public var alertView:PMAlertView!
    public var setupOnceInViewWillAppear:Bool = true
    
    //MARK: - • PRIVATE PROPERTIES
    private var setupExecuted:Bool = false
    
    //MARK: - • INITIALISERS
    
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    
    //MARK: - • DEALLOC
    
    deinit {
        // NSNotificationCenter no longer needs to be cleaned up!
    }
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    
    //MARK: - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //
        self.alertView = PMAlertView.new(owner: self)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var execute:Bool = false
        
        if (setupOnceInViewWillAppear) {
            if (!setupExecuted) {
                execute = true
            }
        }else{
            execute = true
        }
        
        if (execute) {
            setupExecuted = true
            //
            self.view.layoutIfNeeded()
            self.setupLayout(screenName: " ")
        }

        //
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    
    
    //MARK: -
    
    public func setupLayout(screenName:String){
        
        //Colors
        self.view.backgroundColor = UIColor.white
        self.scrollViewBackground.backgroundColor = UIColor.clear
        
        //Navigation Controller
        self.navigationItem.title = screenName
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        //
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public func pop(to:Int?) {
        DispatchQueue.main.async {
            
            if let i:Int = to {
                if i == 0 {
                    self.navigationController?.popToRootViewController(animated: true)
                }else if (i > 0){
                    if (i < (self.navigationController?.viewControllers.count)!) {
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[i])!, animated: true)
                    }
                }else{
                    let index:Int = (self.navigationController?.viewControllers.count)! - 1
                    if ((index + i) >= 0) {
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[index + i])!, animated: true)
                    }
                }
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    public func push(to:String!, backButtonTitle:String?) {
        
        if (self.shouldPerformSegue(withIdentifier: to, sender: self)){
            
            if let backSTR:String = backButtonTitle {
                self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: backSTR, style: .plain, target: nil, action: nil)
            }
            
            self.performSegue(withIdentifier: to, sender: self)
        }
    }
    
    public func keyboardWillAppearAlert() {
        print("keyboardWillAppearAlert-baseClass")
    }
    
    public func keyboardWillHideAlert() {
        print("keyboardWillHideAlert-baseClass")
    }
    
    public func connectionAvailable(silenceFeedback:Bool, executionBlock: @escaping () -> Void) {
        
        let connection:InternetHelper = InternetHelper.init()
        if connection.isConnectionReachable {
            
            executionBlock()
        }else{
            if (!silenceFeedback) {
                let alertError:PMAlertView = PMAlertView.new(owner: self)
                alertError.addOption(.normal, App.STR("ALERT_OPTION_OK"), .check, nil) {
                    print("no connection!")
                }
                alertError.show(.no_connection, App.STR("ALERT_MESSAGE_NO_CONNECTION"))
            }
        }
    }
    
    //MARK: - • PUBLIC METHODS
    
    
    //MARK: - • ACTION METHODS
    
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    @objc
    func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollViewBackground.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
        //
        self.view.layoutIfNeeded()
        //
        self.keyboardWillAppearAlert()
    }
    
    @objc
    func keyboardWillHide(notification:Notification) {
        scrollViewBackground.contentInset = .zero
        //
        self.view.layoutIfNeeded()
        //
        self.keyboardWillHideAlert()
    }
}

//MARK: - PROTOCOLS


