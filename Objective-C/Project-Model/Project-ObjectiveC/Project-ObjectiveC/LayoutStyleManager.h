//
//  LayoutStyleManager.h
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    Default     = 0,
    Light       = 1,
    Dark        = 2,
    Special     = 3
} AppStyle;

@interface LayoutStyleManager : NSObject

@property (nonatomic, assign, readonly) AppStyle style;
//
@property (nonatomic, strong) UIColor *colorBackgroundScreen_Light;
@property (nonatomic, strong) UIColor *colorBackgroundScreen_Normal;
@property (nonatomic, strong) UIColor *colorBackgroundScreen_Dark;
@property (nonatomic, strong) UIColor *colorBackgroundScreen_Other;
//
@property (nonatomic, strong) UIColor *colorTextLabel_Light;
@property (nonatomic, strong) UIColor *colorTextLabel_Normal;
@property (nonatomic, strong) UIColor *colorTextLabel_Dark;
@property (nonatomic, strong) UIColor *colorTextLabel_Other;
//
@property (nonatomic, strong) UIColor *colorBackgroundButton_Light;
@property (nonatomic, strong) UIColor *colorBackgroundButton_Normal;
@property (nonatomic, strong) UIColor *colorBackgroundButton_Dark;
@property (nonatomic, strong) UIColor *colorBackgroundButton_Other;

//- (void)setStyle:(AppStyle)newStyle;

@end
