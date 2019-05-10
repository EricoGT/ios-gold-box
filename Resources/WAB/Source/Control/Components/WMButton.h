//
//  WMButton.h
//  Walmart
//
//  Created by Renan Cargnin on 1/9/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMButton : UIButton

@property (nonatomic, copy) void (^buttonPressedBlock)(void);
@property (nonatomic, strong) UIView *shadowBorder;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *normalShadowColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) UIColor *highlightedShadowColor;

- (id)initWithFrame:(CGRect)frame andButtonPressedBlock:(void (^)(void))buttonPressedBlock;
- (void)setup;

@end