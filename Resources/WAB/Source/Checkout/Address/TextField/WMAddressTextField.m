//
//  WMAddressTextField.m
//  Walmart
//
//  Created by Renan Cargnin on 4/28/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "WMAddressTextField.h"

#define kLeftMargin 5.0f

@implementation WMAddressTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = RGBA(200, 200, 200, 1).CGColor;
    self.layer.cornerRadius = 3.0f;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = kLeftMargin;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = kLeftMargin;
    return rect;
}

@end
