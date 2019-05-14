//
//  ShippingDelivery.h
//  Walmart
//
//  Created by Bruno Delgado on 6/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "ShippingEstimate.h"
#import "DeliveryType.h"
#import "CartItem.h"

@protocol ShippingDelivery
@end

@interface ShippingDelivery : JSONModel

@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) ShippingEstimate *minShippingEstimate;
@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, strong) NSArray<DeliveryType> *deliveryTypes;
@property (nonatomic, strong) NSArray<CartItem> *cartItems;
@property (nonatomic, strong) NSDictionary *deliveryTypePriceMap;
@property (nonatomic, strong) NSNumber *defaultDeliveryTypeId;
@property (nonatomic, assign) BOOL isWalmartSeller;

@property (strong, nonatomic) DeliveryType<Ignore> *selectedDelivery;

- (BOOL)hasScheduledDelivery;
- (DeliveryType *)cheapestDelivery;
- (NSDictionary *)selectedDeliveryDictionary;
- (DeliveryType *)scheduledDelivery;

@end
