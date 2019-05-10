//
//  WMPicker.m
//  Walmart
//
//  Created by Renan on 6/12/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMPicker.h"

#import "UIImage+Additions.h"

@implementation WMPicker

- (WMPicker *)init {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setOpaque:NO];
    [toolBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"OK  "
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(pressedOk)];
    [barButtonDone setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:16.0f],
                                            NSForegroundColorAttributeName: RGBA(26, 117, 207, 1)} forState:UIControlStateNormal];
    toolBar.items = @[flex, barButtonDone];
    
//    self = [super initWithFrame:CGRectMake(0, toolBar.frame.size.height, screenWidth, 162.0f)];
    
    //Exclusive for iPhone X
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        
        LogInfo(@"topPadding    : %f", topPadding);
        LogInfo(@"bottomPadding : %f", bottomPadding);
        
        if (bottomPadding > 0) {
            self = [super initWithFrame:CGRectMake(0, toolBar.frame.size.height-25, screenWidth, 162.0f)];
        }
        else {
            self = [super initWithFrame:CGRectMake(0, toolBar.frame.size.height, screenWidth, 162.0f)];
        }
    }
    else {
        self = [super initWithFrame:CGRectMake(0, toolBar.frame.size.height, screenWidth, 162.0f)];
    }
    
    if (self) {
        self.backgroundColor = RGBA(255, 255, 255, 1);
        self.showsSelectionIndicator = YES;
        
        self.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0f];
        
        self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, toolBar.frame.size.height + self.frame.size.height)];
        self.inputView.backgroundColor = [UIColor clearColor];
        [self.inputView addSubview:self];
        [self.inputView addSubview:toolBar];
    }
    return self;
}

- (void)pressedOk {
    if ([self.wmPickerDelegate respondsToSelector:@selector(pressedOk)]) {
        [self.wmPickerDelegate pressedOk];
    }
}

@end
