//
//  PaymentSummaryView.h
//  Walmart
//
//  Created by Renan Cargnin on 04/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"

@protocol PaymentSummaryViewDelegate <NSObject>
@optional
- (void)paymentSummaryViewPressedRemoveCouponWithRedemptionCode:(NSString *)redemptionCode;
@end

@interface PaymentSummaryView : WMView

@property (weak) id <PaymentSummaryViewDelegate> delegate;

@property (weak, nonatomic) NSDictionary *summary;
@property (weak, nonatomic) NSNumber *totalValue;

- (void)setInstallmentsCount:(NSUInteger)installmentsCount installmentsValue:(NSNumber *)installmentsValue;

@end
