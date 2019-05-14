//
//  HubErrorView.m
//  Walmart
//
//  Created by Renan on 2/13/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "RetryErrorView.h"
#import "WMButton.h"
#import "UIImage+Additions.h"
#import "OFMessages.h"

@interface RetryErrorView ()
{
    NSString *message;
}

- (IBAction)retryPressed;

@end

@implementation RetryErrorView

- (UIView *)init
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"RetryErrorView" owner:self options:nil];
    if (subviewArray.count > 0)
    {
        return subviewArray.firstObject;
    }
    return nil;
}

- (RetryErrorView *)initWithMsg:(NSString *)msg
{
    Class class = [self class];
    NSString *nibName = NSStringFromClass(class);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    self = [nibViews objectAtIndex:0];
    if (self)
    {
        message = msg;
        [self setup];
    }
    return self;
}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        //Center Vertically
        NSLayoutConstraint *centerYConstraint =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.superview
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0.0];
        [self.superview addConstraint:centerYConstraint];
        
        //Center Horizontally
        NSLayoutConstraint *centerXConstraint =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.superview
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0.0];
        [self.superview addConstraint:centerXConstraint];
    }
}

- (void)setup
{
    self.msgLabel.text = message;
    self.msgLabel.textColor = RGBA(153, 153, 153, 1);
    [self.retryButton setTitle:TRY_BUTTON forState:UIControlStateNormal];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self layoutIfNeeded];
}

- (CGSize)intrinsicContentSize
{
    CGFloat heightSize = self.retryButton.frame.origin.y + self.retryButton.frame.size.height + 60.0f;
    return CGSizeMake(self.frame.size.width, heightSize);
}

- (void)retryPressed
{
	[self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(retry)])
    {
        [self.delegate retry];
    }
}

@end
