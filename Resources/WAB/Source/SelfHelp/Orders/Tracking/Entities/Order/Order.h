//
//  Order.h
//  Tracking
//
//  Created by Bruno Delgado on 4/17/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "Delivery.h"
#import "Invoice.h"

@protocol Order
@end

@interface Order : JSONModel

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) DeliveryStatus<Optional> *currentStatus;
@property (nonatomic, strong) NSNumber *deliveryCount;
@property (nonatomic, strong) NSNumber *totalItems;
@property (nonatomic, strong) NSArray<Delivery> *deliveries;
@property (nonatomic, strong) Invoice<Optional> *invoice;

@end
