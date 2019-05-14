//
//  TrackingOrderPayment.h
//  Walmart
//
//  Created by Bruno Delgado on 10/9/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "TrackingOrderTotal.h"
#import "TrackingPaymentMethod.h"

@interface TrackingOrderPayment : JSONModel

@property (nonatomic, strong) TrackingOrderTotal *orderTotal;
@property (nonatomic, strong) NSArray<TrackingPaymentMethod> *paymentMethods;

@end
