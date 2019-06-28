//
//  ModelViewController.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 28/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

//MARK: - • INTERFACE HEADERS

//MARK: - • FRAMEWORK HEADERS
import UIKit

//MARK: - • OTHERS IMPORTS

//MARK: - • EXTENSIONS

//MARK: - • LOCAL DEFINES / ENUMS

enum IndexesToReturn {
    
    case root
    case step
    case by(Int)
    
}

//MARK: - • CLASS

class ModelViewController: UIViewController {
    
    //MARK: - • PUBLIC PROPERTIES
    
    var contentLoaded:Bool = false
    var refreshLayout:Bool = false
    var layoutRead:Bool = false
    
    //MARK: - • PRIVATE PROPERTIES
    
    //MARK: - • INITIALISERS
    
    //MARK: - • CUSTOM ACCESSORS (SETS & GETS)
    
    //MARK: - • DEALLOC
    
    //MARK: - • SUPER CLASS OVERRIDES
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        self.view.layoutIfNeeded()
        //
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //
        if refreshLayout {
            self.setupLayout()
        } else if !layoutRead {
            self.setupLayout()
        }
        //
        if !contentLoaded {
            self.loadContent()
            contentLoaded = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        if self.isMovingFromParent {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    }
    
    //MARK: - • CONTROLLER LIFECYCLE
    
    //MARK: - • INTERFACE/PROTOCOL METHODS
    
    //MARK: - • PUBLIC METHODS
    
    func pop(returning:IndexesToReturn, animated:Bool = true) {
        
        DispatchQueue.main.async {
            
            if self.presentingViewController?.presentedViewController == self {
                
                //MODAL flux:
                self.presentingViewController?.dismiss(animated: animated, completion: nil)
                
            } else {
                
                //PUSH flux:
                switch returning {
                    
                case .root :
                    if let vc = App.Delegate.rootViewController {
                        self.navigationController?.popToViewController(vc, animated: animated)
                    }
                    break
                    
                case .step :
                    if let vc = App.Delegate.stepArrayViewController.lastObject() as? UIViewController {
                        self.navigationController?.popToViewController(vc, animated: animated)
                        App.Delegate.stepArrayViewController.removeLast()
                    }
                    break
                    
                case .by(let index):
                    if index == 0 {
                        self.navigationController?.popToRootViewController(animated: animated)
                    } else if index > 0 {
                        if let actualIndex = self.navigationController?.viewControllers.lastIndex(of: self) {
                            if (actualIndex - index) >= 0 {
                                self.navigationController?.popToViewController((self.navigationController?.viewControllers[actualIndex - index])!, animated: animated)
                            }
                        }
                    }
                    break
                }
                
                App.Delegate.stepArrayViewController.compact()
            }
        }
    }
    
    func segue(to:String, backButtonTitle:String?) {
        
        if (self.shouldPerformSegue(withIdentifier: to, sender: self)){
            if let backSTR:String = backButtonTitle {
                self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: backSTR, style: .plain, target: nil, action: nil)
            }
            self.performSegue(withIdentifier: to, sender: self)
        }
    }
    
    //MARK: - • ACTION METHODS
    
    //MARK: - • PRIVATE METHODS (INTERNAL USE ONLY)
    
    func setupLayout() {
        fatalError("\(#function) method must be override in subclass of ModelViewController.")
    }
    
    func loadContent() {
        fatalError("\(#function) method must be override in subclass of ModelViewController.")
    }
    
    func systemKeyboardShow(height:CGFloat, animationDuration:TimeInterval, animationCurve:UIView.AnimationOptions) -> Void {
        fatalError("\(#function) method must be override in subclass of ModelViewController.")
    }
    
    func systemKeyboardHide() -> Void {
        fatalError("\(#function) method must be override in subclass of ModelViewController.")
    }
    
    func defaultSetup(_ screenTitle:String) {
        
        self.navigationItem.title = screenTitle
        //
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        //
        self.navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15.0)]
        //
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc private func keyboardWillShow(_ notification : Notification?) -> Void {
        
        if let info = notification?.userInfo {
            let curveUserInfoKey    = UIResponder.keyboardAnimationCurveUserInfoKey
            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            //
            var animationCurve:UIView.AnimationOptions = .curveEaseOut
            var animationDuration:TimeInterval = 0.25
            var height:CGFloat = CGFloat.zero
            
            //  Getting keyboard animation.
            if let curve = info[curveUserInfoKey] as? UIView.AnimationOptions {
                animationCurve = curve
            }
            
            //  Getting keyboard animation duration
            if let duration = info[durationUserInfoKey] as? TimeInterval {
                animationDuration = duration
            }
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                height = kbFrame.size.height
            }
            
            self.systemKeyboardShow(height: height, animationDuration: animationDuration, animationCurve: animationCurve)
        }
    }
    
    @objc private func keyboardWillHide(_ notification : Notification?) -> Void {
        self.systemKeyboardHide()
    }
}
