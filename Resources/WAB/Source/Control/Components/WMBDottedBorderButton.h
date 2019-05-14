//
//  WMBDottedBorderButton.h
//  Walmart
//
//  Created by Rafael Valim on 03/07/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface WMBDottedBorderButton : UIButton

@property (nonatomic) IBInspectable NSInteger paintedSize;
@property (nonatomic) IBInspectable NSInteger notPaintedSize;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end
