//
//  UIView+Radius.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UIView+Radius.h"

@implementation UIView (Radius)

- (void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
