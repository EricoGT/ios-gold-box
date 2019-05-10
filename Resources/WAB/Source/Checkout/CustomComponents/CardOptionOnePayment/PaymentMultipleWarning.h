//
//  PaymentMultipleWarning.h
//  CustomComponents
//
//  Created by Marcelo Santos on 2/26/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMView.h"

@protocol delegateSimplePayment <NSObject>
@required
- (void) simplePaymentOption;
@end

@interface PaymentMultipleWarning : WMView

@property (weak) id <delegateSimplePayment> delegate;

@end
