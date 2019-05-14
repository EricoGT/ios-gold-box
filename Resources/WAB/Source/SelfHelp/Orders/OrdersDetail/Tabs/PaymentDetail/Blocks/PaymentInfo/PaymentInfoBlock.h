//
//  PaymentInfoBlock.h
//  Tracking
//
//  Created by Bruno Delgado on 29/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingViewWithXib.h"
#import "TrackingOrderPayment.h"
#import "TrackingPaymentMethod.h"
#import "TrackingOrderTotal.h"

@interface PaymentInfoBlock : TrackingViewWithXib

- (void)setupWithPaymentInfo:(TrackingPaymentMethod *)paymentMethod total:(TrackingOrderTotal *)total paymentIndex:(NSUInteger)index;

@end
