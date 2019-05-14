//
//  WMModalLoadingView.m
//  Walmart
//
//  Created by Renan Cargnin on 12/30/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import "WMModalLoadingView.h"

@interface WMModalLoadingView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLeadingConstraint;

@end

@implementation WMModalLoadingView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupConstraints];
    }
    
    return self;
}

- (void)setupConstraints
{
    if (IS_IPHONE_6)
    {
        _alertTrailingConstraint.constant = 30;
        _alertLeadingConstraint.constant = 30;
    }
    else if (IS_IPHONE_6P)
    {
        _alertTrailingConstraint.constant = 68;
        _alertLeadingConstraint.constant = 68;
    }
    
    [self layoutIfNeeded];
}

@end
