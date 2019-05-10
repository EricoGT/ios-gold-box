//
//  PaymentMultipleWarning.m
//  CustomComponents
//
//  Created by Marcelo Santos on 2/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "PaymentMultipleWarning.h"

@implementation PaymentMultipleWarning

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPaymentMultipleWarningView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPaymentMultipleWarningView];
    }
    return self;
}

- (void)setupPaymentMultipleWarningView {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
}

- (IBAction)simplePaymentChoosed:(id)sender {
    if ([_delegate respondsToSelector:@selector(simplePaymentOption)]) {
        [_delegate simplePaymentOption];
    }
}

@end
