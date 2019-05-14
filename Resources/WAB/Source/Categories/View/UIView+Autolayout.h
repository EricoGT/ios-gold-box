//
//  UIView+Autolayout.h
//  Walmart
//
//  Created by Bruno Delgado on 4/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Autolayout)

- (void)pinTopToView:(UIView *)viewToPin;
- (void)pinBottomToView:(UIView *)viewToPin;
- (void)pinLeadingToView:(UIView *)viewToPin;
- (void)pinTrailingToView:(UIView *)viewToPin;

- (void)matchParentView;
- (void)matchView:(UIView *)parent;

@end
