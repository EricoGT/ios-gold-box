//
//  Delivery.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "DeliveryItem.h"
#import "DeliveryStatus.h"

@protocol Delivery
@end

@interface Delivery : JSONModel

@property (nonatomic, strong) NSString *deliveryId;
@property (nonatomic, strong) NSString<Optional> *shippingEstimateDate;
@property (nonatomic, strong) DeliveryStatus<Optional> *currentStatus;
@property (nonatomic, strong) NSArray<DeliveryItem> *items;


@end
