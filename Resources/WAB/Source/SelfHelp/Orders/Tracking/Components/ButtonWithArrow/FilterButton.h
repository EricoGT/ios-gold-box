//
//  ButtonWithArrow.h
//  Tracking
//
//  Created by Bruno Delgado on 4/24/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterButton : UIView

@property (nonatomic, strong) UIButton *button;

- (BOOL)isSelected;
- (void)setSelected:(BOOL)selected;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)activate;
- (void)deactivate;

@end
