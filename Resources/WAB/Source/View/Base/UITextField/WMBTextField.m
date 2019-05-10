//
//  WMBTextField.m
//  Walmart
//
//  Created by Renan Cargnin on 30/09/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBTextField.h"

#define kHorizontalPadding 10.0f

@implementation WMBTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWMBTextField];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWMBTextField];
    }
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setupWMBTextField];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect defaultRect = [super textRectForBounds:bounds];
    defaultRect.origin.x = kHorizontalPadding;
    return defaultRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect defaultRect = [super editingRectForBounds:bounds];
    defaultRect.origin.x = kHorizontalPadding;
    return defaultRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect defaultRect = [super placeholderRectForBounds:bounds];
    defaultRect.origin.x = kHorizontalPadding;
    return defaultRect;
}

- (void)setupWMBTextField {
    self.layer.borderColor = RGB(232, 232, 232).CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
