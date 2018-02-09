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
            //viewWidth.constant = originalExpandedWidth * (factor > 1.0 ? 1.0 : (factor < 0.0 ? 0.0 : factor))
            //
            self.updateConstraintsValues(animated)
        }
        
    }
    
    func compressVertically(factor:CGFloat, animated:Bool){
        
        if (isRegistered){
            self.isHidden = true
            //
            //viewHeight.constant = originalExpandedHeight * (factor > 1.0 ? 1.0 : (factor < 0.0 ? 0.0 : factor))
            //
            self.updateConstraintsValues(animated)
        }
    }
    
    func expandHorizontally(animated:Bool){
        
        if (isRegistered){
            self.isHidden = false

            for c in superConstraints{
                if c.constraint.firstAttribute == .left || c.constraint.firstAttribute == .leftMargin || c.constraint.secondAttribute == .left || c.constraint.secondAttribute == .leftMargin || c.constraint.firstAttribute == .leading || c.constraint.firstAttribute == .leadingMargin || c.constraint.secondAttribute == .leading || c.constraint.secondAttribute == .leadingMargin{
                    c.constraint.constant = c.oldConstant
                }
                if c.constraint.firstAttribute == .right || c.constraint.firstAttribute == .rightMargin || c.constraint.secondAttribute == .right || c.constraint.secondAttribute == .rightMargin || c.constraint.firstAttribute == .trailing || c.constraint.firstAttribute == .trailingMargin || c.constraint.secondAttribute == .trailing || c.constraint.secondAttribute == .trailingMargin{
                    c.constraint.constant = c.oldConstant
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
                if c.constraint.firstAttribute == .top || c.constraint.firstAttribute == .topMargin{
                    c.constraint.constant = c.oldConstant
                }else{
                    if c.constraint.secondAttribute == .bottom || c.constraint.secondAttribute == .bottomMargin{
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
                if c.constraint.firstAttribute == .left || c.constraint.firstAttribute == .leftMargin || c.constraint.secondAttribute == .left || c.constraint.secondAttribute == .leftMargin || c.constraint.firstAttribute == .leading || c.constraint.firstAttribute == .leadingMargin || c.constraint.secondAttribute == .leading || c.constraint.secondAttribute == .leadingMargin{
                    c.oldConstant = c.constraint.constant
                    c.constraint.constant = 0.0
                }
                if c.constraint.firstAttribute == .right || c.constraint.firstAttribute == .rightMargin || c.constraint.secondAttribute == .right || c.constraint.secondAttribute == .rightMargin || c.constraint.firstAttribute == .trailing || c.constraint.firstAttribute == .trailingMargin || c.constraint.secondAttribute == .trailing || c.constraint.secondAttribute == .trailingMargin{
                    c.oldConstant = c.constraint.constant
                    c.constraint.constant = 0.0
                }
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
                if c.constraint.firstAttribute == .top || c.constraint.firstAttribute == .topMargin{
                    c.oldConstant = c.constraint.constant
                    c.constraint.constant = 0.0
                }else{
                    if c.constraint.secondAttribute == .bottom || c.constraint.secondAttribute == .bottomMargin{
                        c.oldConstant = c.constraint.constant
                        //c.constraint.constant = 0.0
                    }
                }
                
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
//        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: self.animationTime(), animations: {
                    self.superview?.layoutIfNeeded()
                })
            }else{
                self.superview?.layoutIfNeeded()
            }
//        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
