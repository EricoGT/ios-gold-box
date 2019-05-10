//
//  WMView.m
//  Walmart
//
//  Created by Renan Cargnin on 1/7/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@interface WMView ()

@property (weak, nonatomic) UIView *contentView;

@end

@implementation WMView

- (instancetype)init {
    if (self = [super init]) {
        [self setFrame:_contentView.bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupWMView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupWMView];
    }
    return self;
}

- (void)setupWMView {
    if ([self class] == [WMView class]) {
        LogInfo(@"You must subclass WMView. Don't use it directly ;)");
        return;
    }
    
    self.contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = _contentView.backgroundColor;
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    [self pinView:_contentView attribute:NSLayoutAttributeTop];
    [self pinView:_contentView attribute:NSLayoutAttributeBottom];
    [self pinView:_contentView attribute:NSLayoutAttributeLeft];
    [self pinView:_contentView attribute:NSLayoutAttributeRight];
}

- (void)pinView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:attribute
                                                    multiplier:1
                                                      constant:0.0f]];
}

@end
