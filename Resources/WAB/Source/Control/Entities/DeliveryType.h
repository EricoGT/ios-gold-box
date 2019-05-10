//
//  DeliveryType.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "DeliveryWindowOption.h"

@protocol DeliveryType
@end

typedef enum : NSUInteger {
    ShippingTypeNormal = 1,
    ShippingTypeScheduled = 5,
    ShippingTypeConcierge = 12,
} ShippingType;

@interface DeliveryType : JSONModel

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *deliveryTypeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shippingEstimate;
@property (nonatomic, strong) NSDictionary *deliveryWindowMap;
@property (nonatomic, strong) NSString<Optional> *firstAvailableStartDate;
@property (nonatomic, strong) DeliveryWindowOption *firstAvailableWindow;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) NSNumber *shippingEstimateInDays;
@property (nonatomic, strong) NSString *shippingEstimateTimeUnit;

@property (nonatomic, strong) NSDictionary<Ignore> *priceMap;
@property (strong, nonatomic) NSDictionary<Ignore> *selectedScheduledDeliveryPeriod;

// Convenience methods
- (BOOL)isScheduledShipping;
- (BOOL)isConcierge;

- (NSString *)shippingEstimate;
- (NSString *)deliveryPrice;
- (NSString *)selectedScheduledDeliveryFormattedString;

@end
