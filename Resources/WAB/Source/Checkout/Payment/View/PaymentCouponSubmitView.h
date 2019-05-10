//
//  PaymentCouponSubmitView.h
//  Walmart
//
//  Created by Renan Cargnin on 03/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

#import "CouponSubmitView.h"

@protocol PaymentCouponSubmitView <NSObject>
@optional
- (void)paymentCouponSubmitViewPressedSubmitWithRedemptionCode:(NSString *)redemptionCode;
@end

@interface PaymentCouponSubmitView : WMView

@property (weak) id <PaymentCouponSubmitView> delegate;

@property (weak, nonatomic) IBOutlet CouponSubmitView *couponSubmitView;

@end
