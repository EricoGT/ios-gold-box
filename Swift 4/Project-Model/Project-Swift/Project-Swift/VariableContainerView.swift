//
//  VariableContainerView.swift
//  Etna
//
//  Created by Erico GT on 08/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

public enum VariableContainerViewAnimationSpeed:Int {
    case slow = 0
    case normal = 1
    case fast = 2
}

class NSLayoutConstraintPlus:NSObject{
    var oldConstant:CGFloat = 0.0
    var constraint:NSLayoutConstraint = NSLayoutConstraint.init()
}

class VariableContainerView: UIScrollView {

    //public
    var animationSpeed:VariableContainerViewAnimationSpeed = .normal
    
    //private
    private var isRegistered:Bool = false
    //
    private var superConstraints:Array<NSLayoutConstraintPlus> = Array.init()
    private var selfConstraints:Array<NSLayoutConstraintPlus> = Array.init()
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        //
//        topConstraint = NSLayoutConstraint.init()
//    }
    
    func registerLayoutConstraints(){
        
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        if let constraints = self.superview?.constraints{
            
            for constraint in constraints{
                
                if ((constraint.firstItem as? VariableContainerView) == self || (constraint.secondItem as? VariableContainerView) == self){
                    
                    let cPlus = NSLayoutConstraintPlus.init()
                    cPlus.constraint = constraint
                    cPlus.oldConstant = constraint.constant
                    superConstraints.append(cPlus)
                }
            }
        }
        
        for constraint in self.constraints {
            
            if ((constraint.firstItem as? VariableContainerView) == self){
                
                let cPlus = NSLayoutConstraintPlus.init()
                cPlus.constraint = constraint
                cPlus.oldConstant = constraint.constant
                selfConstraints.append(cPlus)
                
            }
        }
        
        isRegistered = true
        
        self.superview?.layoutIfNeeded()
    }
    
    func compressHorizontally(factor:CGFloat, animated:Bool){
        
        if (isRegistered){
            self.isHidden = true
            //
            for c in selfConstraints{
                if (c.constraint.firstAttribute == .width){
                    c.constraint.constant =  c.oldConstant * (factor > 1.0 ? 1.0 : (factor < 0.0 ? 0.0 : factor))
                    break
                }
            }
            //
            self.updateConstraintsValues(animated)
        }
        
    }
    
    func compressVertically(factor:CGFloat, animated:Bool){
        
        if (isRegistered){
            self.isHidden = true
            //
            for c in selfConstraints{
                if (c.constraint.firstAttribute == .height){
                    c.constraint.constant =  c.oldConstant * (factor > 1.0 ? 1.0 : (factor < 0.0 ? 0.0 : factor))
                    break
                }
            }
            //
            self.updateConstraintsValues(animated)
        }
    }
    
    func expandHorizontally(animated:Bool){
        
        if (isRegistered){
            self.isHidden = false

            for c in superConstraints{
                if (c.constraint.firstItem as? VariableContainerView) == self{
                    if c.constraint.firstAttribute == .left || c.constraint.firstAttribute == .leftMargin || c.constraint.firstAttribute == .leading || c.constraint.firstAttribute == .leadingMargin{
                        c.constraint.constant = c.oldConstant
                    }
                }
            }
            
            for c in selfConstraints{
                if c.constraint.firstAttribute == .width{
                    c.constraint.constant = c.oldConstant
                }
            }
            
            self.updateConstraintsValues(animated)
        }
    }
    
    func expandVertically(animated:Bool){
        
        if (isRegistered){
            self.isHidden = false

            for c in superConstraints{
                if (c.constraint.firstItem as? VariableContainerView) == self{
                    if c.constraint.firstAttribute == .top || c.constraint.firstAttribute == .topMargin{
                        c.constraint.constant = c.oldConstant
                    }
                }
            }
            
            for sc in selfConstraints{
                if sc.constraint.firstAttribute == .height{
                    sc.constraint.constant = sc.oldConstant
                }
            }
            
            self.updateConstraintsValues(animated)
        }
    }
    
    func hideHorizontallyFromParent(animated:Bool){
        
        if (isRegistered){

            for c in superConstraints{
                //Esconde o componente anulando as left constants
                if (c.constraint.firstItem as? VariableContainerView) == self{
                    if c.constraint.firstAttribute == .left || c.constraint.firstAttribute == .leftMargin || c.constraint.firstAttribute == .leading || c.constraint.firstAttribute == .leadingMargin{
                        c.oldConstant = c.constraint.constant
                        c.constraint.constant = 0.0
                    }
                }
                //Para esconder o bottom é preciso varrer 'c.constraint.secondItem'
            }
            
            for c in selfConstraints{
                if c.constraint.firstAttribute == .width{
                    c.oldConstant = c.constraint.constant
                    c.constraint.constant = 0.0
                }
            }

            self.updateConstraintsValues(animated)
        }
    }
    
    func hideVerticallyFromParent(animated:Bool){
        
        if (isRegistered){
            
            for c in superConstraints{
                //Esconde o componente anulando as top constants
                if (c.constraint.firstItem as? VariableContainerView) == self{
                    if c.constraint.firstAttribute == .top || c.constraint.firstAttribute == .topMargin{
                        c.oldConstant = c.constraint.constant
                        c.constraint.constant = 0.0
                    }
                }
                //Para esconder o bottom é preciso varrer 'c.constraint.secondItem'
            }
            
            for sc in selfConstraints{
                if sc.constraint.firstAttribute == .height{
                    sc.oldConstant = sc.constraint.constant
                    sc.constraint.constant = 0.0
                }
            }
            
            self.updateConstraintsValues(animated)
        }
    }
    
    private func animationTime() -> TimeInterval{
        
        switch animationSpeed {
        case .slow:
            return 0.6
        case .normal:
            return 0.3
        case .fast:
            return 0.15
        }
    }
    
    private func updateConstraintsValues(_ animated:Bool){

        if animated {
            UIView.animate(withDuration: self.animationTime(), animations: {
                self.superview?.layoutIfNeeded()
            })
        }else{
            self.superview?.layoutIfNeeded()
        }
    }

}
