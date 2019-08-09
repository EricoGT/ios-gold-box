//
//  UIButton+Extensions.swift
//  ShadowCell
//
//  Created by Erico Gimenes Teixeira on 08/08/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

class Button : UIButton {
    
    enum HitTestMethod: UInt {
        case normal = 0
        case image = 1
        case text = 2
        case imageOrText = 3
    }
    
    var hitTestMethod:HitTestMethod = .normal
    var rippleEffectColor: UIColor?
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var viewHitted:UIView? = nil
        
        switch self.hitTestMethod {
            
        case .normal:
            viewHitted = super.hitTest(point, with: event)
        
        case .image:
            viewHitted = self.checkHitInImage(point: point)
            
        case .text:
            viewHitted = self.checkHitInText(point: point)
            
        case .imageOrText:
            if let view = self.checkHitInImage(point: point) {
                viewHitted = view
            }
            viewHitted = self.checkHitInText(point: point)
            
        }
        
        if let _ = viewHitted, let color = self.rippleEffectColor {
            self.applyRippleEffect(inView: self, innerPoint: point, duration: 0.5, color: color)
        }
        return viewHitted
    }
    
    private func checkHitInImage(point:CGPoint) -> UIView? {
        if let imgView = self.imageView {
            if !imgView.bounds.contains(point) {
                return nil
            }
            let color:UIColor = self.getColourFromPoint(point: point)
            let alpha = color.cgColor.alpha
            //5% tolerance
            if alpha <= 0.05 {
                return nil
            }
            
            return self
        }
        
        return nil
    }
    
    private func checkHitInText(point:CGPoint) -> UIView? {
        if let label = self.titleLabel {
            if label.frame.contains(point) {
                return self
            }
        }
        return nil
    }
    
    private func getColourFromPoint(point:CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        
        let red:CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
    
    private func applyRippleEffect(inView:UIView, innerPoint:CGPoint, duration: CFTimeInterval, color:UIColor?) -> Void {
        
        //top left:
        let d1 = hypot(innerPoint.x, innerPoint.y)
        //top right:
        let d2 = hypot(innerPoint.x - (inView.frame.size.width), innerPoint.y)
        //bottom left:
        let d3 = hypot(innerPoint.x, innerPoint.y - (inView.frame.size.height))
        //bottom  right:
        let d4 = hypot(innerPoint.x - (inView.frame.size.width), innerPoint.y - (inView.frame.size.height))
        
        let radius = max( max(d1, d2) , max(d3, d4)) + 1.0
        let circularRect = CGRect.init(x: innerPoint.x - radius, y: innerPoint.y - radius, width: radius * 2.0, height: radius * 2.0)
        
        let startPath:UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: innerPoint.x, y: innerPoint.y, width: 1.0, height: 1.0), cornerRadius: 1)
        let endPath:UIBezierPath = UIBezierPath.init(roundedRect: circularRect, cornerRadius: radius)
        
        let circleShape:CAShapeLayer = CAShapeLayer.init()
        circleShape.path = startPath.cgPath
        circleShape.fillColor = color?.cgColor ?? UIColor.white.cgColor
        inView.layer.masksToBounds = true
        inView.layer.addSublayer(circleShape)
        
        // Begin the transaction
        CATransaction.begin()
        
        let group = CAAnimationGroup.init()
        group.fillMode = .both
        group.duration = duration
        group.isRemovedOnCompletion = true
        
        let animationPath = CABasicAnimation.init(keyPath: "path")
        //animation.delegate = self
        animationPath.fromValue = startPath.cgPath
        animationPath.toValue = endPath.cgPath
        animationPath.duration = duration
        animationPath.isRemovedOnCompletion = false
        animationPath.fillMode = .forwards
        animationPath.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animationPath.beginTime = 0.0
        
        let animationAlpha = CABasicAnimation.init(keyPath: "opacity")
        //animation.delegate = self
        animationAlpha.fromValue = 1.0
        animationAlpha.toValue = 0.01
        animationAlpha.duration = duration
        animationAlpha.isRemovedOnCompletion = false
        animationAlpha.fillMode = .forwards
        animationAlpha.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animationAlpha.beginTime = 0.0
        
        group.animations = [animationPath, animationAlpha]
        
        // Callback function
        CATransaction.setCompletionBlock {
            //inView.backgroundColor = color
            circleShape.removeFromSuperlayer()
        }
        
        // Do the actual animation and commit the transaction
        circleShape.add(group, forKey: "rippleAnimation")
        CATransaction.commit()
    }
    
}

//extension UIButton: CAAnimationDelegate {
//
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//
//    }
//
//}
