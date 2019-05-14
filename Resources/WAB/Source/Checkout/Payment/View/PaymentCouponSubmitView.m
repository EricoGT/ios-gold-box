//
//  PaymentCouponSubmitView.m
//  Walmart
//
//  Created by Renan Cargnin on 03/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "PaymentCouponSubmitView.h"

@interface PaymentCouponSubmitView ()

@end

@implementation PaymentCouponSubmitView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPaymentCouponSubmitView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPaymentCouponSubmitView];
    }
    return self;
}

- (void)setupPaymentCouponSubmitView {
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = RGB(201, 201, 201).CGColor;
    
    _couponSubmitView.submitBlock = ^(NSString *redemptionCode) {
        if ([self->_delegate respondsToSelector:@selector(paymentCouponSubmitViewPressedSubmitWithRedemptionCode:)]) {
            [self->_delegate paymentCouponSubmitViewPressedSubmitWithRedemptionCode:redemptionCode];
        }
    };
}

@end
