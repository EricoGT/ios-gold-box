//
//  Invoice.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "Payment.h"

@protocol Invoice
@end

@interface Invoice : JSONModel

@property (nonatomic, strong) NSString<Optional> *order;
@property (nonatomic, strong) NSNumber<Optional> *deliveryRatePrice;
@property (nonatomic, strong) NSNumber<Optional> *servicePrice;
@property (nonatomic, strong) NSNumber<Optional> *totalPrice;
@property (nonatomic, strong) NSArray<Payment, Optional> *currentPayments;

@end
