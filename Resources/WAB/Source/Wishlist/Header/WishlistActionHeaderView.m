//
//  WishlistActionHeaderView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/7/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WishlistActionHeaderView.h"

#define kAnimationDuration 0.3f

@interface WishlistActionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *alreadyBoughtButton;

@property (strong, nonatomic) NSLayoutConstraint *animationConstraint;

@end

@implementation WishlistActionHeaderView

- (WishlistActionHeaderView *)initWithSuperview:(UIView *)superview selectedCount:(NSUInteger)selectedCount delegate:(id<WishlistActionHeaderViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        
        [self setup];
        [self setSuperview:superview];
        [self setSelectedCount:selectedCount];
    }
    return self;
}

#pragma mark - Setup
- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.hidden = YES;
}

- (void)setSuperview:(UIView *)superview {
    [self removeFromSuperview];
    
    [superview addSubview:self];
    
    self.animationConstraint = [self constraintToView:superview attribute:NSLayoutAttributeTop constant:-self.bounds.size.height];
    
    [superview addConstraints:@[_animationConstraint,
                               [self constraintToView:superview attribute:NSLayoutAttributeLeading constant:0.0f],
                               [self constraintToView:superview attribute:NSLayoutAttributeTrailing constant:0.0f]]];
}

- (void)setSelectedCount:(NSUInteger)selectedCount {
    _selectedCountLabel.text = [NSString stringWithFormat:@"%lu selecionado%@", (unsigned long) selectedCount, selectedCount > 1 ? @"s" : @""];
}

#pragma mark - Auto Layout
- (NSLayoutConstraint *)constraintToView:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:attribute
                                       multiplier:1.0f
                                         constant:constant];
}

#pragma mark - Animations
- (void)show {
    self.hidden = NO;
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self->_animationConstraint.constant = 20.0f;
        [self.superview layoutIfNeeded];
    }];
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        self.userInteractionEnabled = NO;
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self->_animationConstraint.constant = -self.bounds.size.height;
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.userInteractionEnabled = YES;
        }];
    }
    else {
        self.hidden = YES;
        _animationConstraint.constant = -self.bounds.size.height;
        [self.superview layoutIfNeeded];
    }
}

#pragma mark - AlreadyBoughtButton
- (void)hideAlreadyBoughtButton {
    _alreadyBoughtButton.hidden = YES;
}

- (void)showAlreadyBoughtButton {
    _alreadyBoughtButton.hidden = NO;
}

#pragma mark - IBAction
- (IBAction)tappedBack:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(wishlistActionHeaderTappedBack)]) {
        [_delegate wishlistActionHeaderTappedBack];
    }
}

- (IBAction)tappedAlreadyBought:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(wishlistActionHeaderTappedAlreadyBought)]) {
        [_delegate wishlistActionHeaderTappedAlreadyBought];
    }
}

- (IBAction)tappedRemove:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(wishlistActionHeaderTappedRemove)]) {
        [_delegate wishlistActionHeaderTappedRemove];
    }
}

@end
