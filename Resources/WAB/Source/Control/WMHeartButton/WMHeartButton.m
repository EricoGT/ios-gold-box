//
//  WMHeartButton.m
//  Walmart
//
//  Created by Bruno on 11/24/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMHeartButton.h"

@interface WMHeartButton ()

@property (nonatomic, strong) UIImageView *emptyHeartImageView;
@property (nonatomic, strong) UIImageView *fullHeartImageView;
@property (nonatomic, assign) BOOL favorite;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation WMHeartButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.animationDuration = 0.25;
    if (!_emptyHeartImageView) {
        self.emptyHeartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _emptyHeartImageView.image = [UIImage imageNamed:@"ic_heart_line"];
        _emptyHeartImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_emptyHeartImageView];
    }
    
    if (!_fullHeartImageView) {
        self.fullHeartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _fullHeartImageView.image = [UIImage imageNamed:@"ic_heart_red"];
        _fullHeartImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_fullHeartImageView];
    }
    
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    
    _fullHeartImageView.alpha = 0;
    _emptyHeartImageView.alpha = 1;
    self.isAnimating = NO;
    self.favorite = NO;
}

- (void)buttonPushed
{
    if (_favorite) {
        [self unfavoriteAnimated:YES];
    } else {
        [self favoriteAnimated:YES];
    }
}

- (void)favoriteAnimated:(BOOL)animated
{
    if (_isAnimating) return;
    
    self.favorite = YES;
    [self stopPulsing];
    
    _fullHeartImageView.transform = CGAffineTransformIdentity;
    _fullHeartImageView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    _fullHeartImageView.alpha = 1;
    
    if (animated)
    {
        self.isAnimating = YES;
        [UIView animateWithDuration:.15 animations:^{
            self->_emptyHeartImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
        } completion:^(BOOL finished) {
            self->_emptyHeartImageView.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:.2 animations:^{
            self->_fullHeartImageView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                self->_fullHeartImageView.transform = CGAffineTransformIdentity;
                self.isAnimating = NO;
            }];
        }];
    }
    else
    {
        _fullHeartImageView.transform = CGAffineTransformIdentity;
        _fullHeartImageView.alpha = 1;
    }
}

- (void)unfavoriteAnimated:(BOOL)animated
{
    if (_isAnimating) return;
    
    self.favorite = NO;
    [self stopPulsing];
    
    if (animated)
    {
        self.isAnimating = YES;
        [UIView animateWithDuration:.1 animations:^{
            self->_fullHeartImageView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 animations:^{
                self->_fullHeartImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            } completion:^(BOOL finished) {
                self->_fullHeartImageView.alpha = 0;
                self.isAnimating = NO;
            }];
        }];
    }
    else
    {
        _fullHeartImageView.transform = CGAffineTransformIdentity;
        _fullHeartImageView.alpha = 0;
    }
}

- (void)pulse {
    _favorite ? [self pulseFullHeart] : [self pulseEmptyHeart];
}

- (void)pulseEmptyHeart
{
    _fullHeartImageView.alpha = 0;
    self.userInteractionEnabled = NO;
    
    CABasicAnimation *transformAnimation;
    transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnimation.fromValue = @1.00;
    transformAnimation.toValue = @1.15;
    transformAnimation.duration = .3;
    transformAnimation.cumulative = NO;
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.repeatCount = INFINITY;
    transformAnimation.autoreverses = YES;
    [_emptyHeartImageView.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
}

- (void)pulseFullHeart
{
    _fullHeartImageView.alpha = 1;
    self.userInteractionEnabled = NO;
    
    CABasicAnimation *transformAnimation;
    transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnimation.fromValue = @1.00;
    transformAnimation.toValue = @1.15;
    transformAnimation.duration = .3;
    transformAnimation.cumulative = NO;
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.repeatCount = INFINITY;
    transformAnimation.autoreverses = YES;
    [_fullHeartImageView.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
}

- (void)stopPulsing
{
    self.userInteractionEnabled = YES;
    [_emptyHeartImageView.layer removeAllAnimations];
    [_fullHeartImageView.layer removeAllAnimations];
}

- (BOOL)favorite
{
    return _favorite;
}

@end
