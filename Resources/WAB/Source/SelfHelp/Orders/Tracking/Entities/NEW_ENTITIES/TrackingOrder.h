//
//  TrackingOrder.h
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "DeliveryTrackingItem.h"
#import "TrackingOrderItem.h"

@protocol TrackingOrder
@end

@interface TrackingOrder : JSONModel

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSArray<TrackingOrderItem> *items;
@property (nonatomic, strong) DeliveryTrackingItem *tracking;
@property (nonatomic, assign) BOOL conciergeDelayed;

@end
