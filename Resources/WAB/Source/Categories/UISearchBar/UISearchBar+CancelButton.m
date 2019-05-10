//
//  UISearchBar+CancelButton.m
//  Walmart
//
//  Created by Renan Cargnin on 2/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "UISearchBar+CancelButton.h"

@implementation UISearchBar (CancelButton)

- (void)customCancelButtonWithTitle:(NSString *)title tintColor:(UIColor *)tintColor {
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:title];
    [barButtonAppearanceInSearchBar setTintColor:tintColor];
}

- (void)reenableCancelButton {
    for (UIView *view in self.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton *) subview;
                cancelButton.enabled = YES;
                break;
            }
        }
    }
}

@end
