//
//  WBRTriangleView.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 8/15/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRTriangleView.h"

@interface WBRTriangleView ()
@property (strong, nonatomic) IBInspectable UIColor *triangleColor;
@property (nonatomic) IBInspectable BOOL pointingToLeft;
@end

@implementation WBRTriangleView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(graphicsContext);
    if (self.pointingToLeft) {
        CGContextMoveToPoint(graphicsContext, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(graphicsContext, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(graphicsContext, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    else {
        CGContextMoveToPoint(graphicsContext, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(graphicsContext, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(graphicsContext, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    }
    CGContextClosePath(graphicsContext);
    
    CGFloat red = CGColorGetComponents(self.triangleColor.CGColor)[0];
    CGFloat green = CGColorGetComponents(self.triangleColor.CGColor)[1];
    CGFloat blue = CGColorGetComponents(self.triangleColor.CGColor)[2];
    CGContextSetRGBFillColor(graphicsContext, red, green, blue, 1);
    CGContextFillPath(graphicsContext);
}

@end
