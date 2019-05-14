//
//  UIView+Autolayout.m
//  Walmart
//
//  Created by Bruno Delgado on 4/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

- (void)pinTopToView:(UIView *)viewToPin
{
    [self pinAttribute:NSLayoutAttributeTop toView:viewToPin];
}

- (void)pinBottomToView:(UIView *)viewToPin
{
    [self pinAttribute:NSLayoutAttributeBottom toView:viewToPin];
}

- (void)pinLeadingToView:(UIView *)viewToPin
{
    [self pinAttribute:NSLayoutAttributeLeading toView:viewToPin];
}

- (void)pinTrailingToView:(UIView *)viewToPin
{
    [self pinAttribute:NSLayoutAttributeTrailing toView:viewToPin];
}

- (void)matchParentView
{
    [self matchView:self.superview];
}

- (void)matchView:(UIView *)parent
{
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    [self pinAttribute:NSLayoutAttributeTop toView:parent];
    [self pinAttribute:NSLayoutAttributeBottom toView:parent];
    [self pinAttribute:NSLayoutAttributeLeading toView:parent];
    [self pinAttribute:NSLayoutAttributeTrailing toView:parent];
}

#pragma mark - Helper
- (void)pinAttribute:(NSLayoutAttribute)attr toView:(UIView *)parent
{
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:parent
                                                       attribute:attr
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:attr
                                                      multiplier:1
                                                        constant:0.0f]];
}

@end
