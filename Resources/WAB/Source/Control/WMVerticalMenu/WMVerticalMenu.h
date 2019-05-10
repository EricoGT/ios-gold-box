//
//  WMVerticalMenu.h
//  Walmart
//
//  Created by Bruno on 7/3/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomMenuButton;
@class WMVerticalMenu;

#define kDistanceBetweenButtons 40
#define kBottomIndicatorViewHeight 4

@protocol WMVerticalMenuDelegate <NSObject>
@required
- (void)WMVerticalMenu:(WMVerticalMenu *)menu didChangeToIndex:(NSInteger)index item:(CustomMenuButton *)menuItem;
@optional
@end

@interface WMVerticalMenu : UIView

@property (nonatomic, assign) CGFloat distanceBetweenButtons;
@property (nonatomic, weak) id<WMVerticalMenuDelegate> delegate;

#pragma mark - Setup
- (instancetype)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons;
- (void)setLayout;
- (void)addButtons:(NSArray *)buttons;

#pragma mark - Update
- (void)activateMenuAtIndex:(NSInteger)menuIndex;
- (void)activateMenu:(CustomMenuButton *)menuItem;

@end
