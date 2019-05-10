//
//  TrackingOrderDetail.h
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "TrackingDeliveryDetail.h"
#import "TrackingOrderPayment.h"
#import "Kit.h"

@interface TrackingOrderDetail : JSONModel

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, assign) BOOL cancelable;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSArray<TrackingDeliveryDetail> *deliveries;
@property (nonatomic, strong) TrackingOrderPayment *payment;
@property (nonatomic, strong) NSArray<Kit, Optional> *kits;

@end
