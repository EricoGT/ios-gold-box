//
//  DeliveryTrackingItem.h
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
@protocol DeliveryTrackingItem
@end

@interface DeliveryTrackingItem : JSONModel

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSDate *eventDate;
@property (nonatomic, strong) NSNumber<Optional> *trackingDelivery;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate<Optional> *shippingEstimateDate;
@property (nonatomic, strong) NSDate<Optional> *expectedDeliveryDate;
@property (nonatomic, strong) NSString<Optional> *messageDate;

@end
