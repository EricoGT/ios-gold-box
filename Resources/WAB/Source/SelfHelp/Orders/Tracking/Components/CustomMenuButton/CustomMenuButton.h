//
//  CustomMenuButton.h
//  Tracking
//
//  Created by Bruno Delgado on 4/29/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();

@interface CustomMenuButton : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *button;
@property (assign, nonatomic) BOOL active;
@property (nonatomic, copy) ActionBlock actionBlock;

- (id)initWithButtonTitle:(NSString *)buttonTitle;
- (void)setBlockForTouchUpInsideEvent:(ActionBlock)action;
- (void)hidesBottomBar;

@end
