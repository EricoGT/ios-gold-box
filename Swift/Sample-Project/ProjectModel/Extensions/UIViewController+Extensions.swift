//
//  UIViewController+Extensions.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 25/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    
    //Custom animations:
    
    func presentFromRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push //kCATransitionPush
        transition.subtype = .fromRight //kCATransitionFromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func presentFromLeft(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .reveal //kCATransitionReveal
        transition.subtype = .fromLeft //kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissFromRight() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push //kCATransitionPush
        transition.subtype = .fromLeft //kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    //Keyboard Notification
    
    //MARK: -
    
    enum IndexesToReturn {
        
        case root
        case step
        case by(Int)
        
    }
    
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
    
    
    
}
