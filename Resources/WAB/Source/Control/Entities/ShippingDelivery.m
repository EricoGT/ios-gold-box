//
//  ShippingDelivery.m
//  Walmart
//
//  Created by Bruno Delgado on 6/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "ShippingDelivery.h"

#import "OFShipmentTemp.h"

@implementation ShippingDelivery

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (BOOL)hasScheduledDelivery {
    for (DeliveryType *type in _deliveryTypes) {
        if ([type isScheduledShipping]) {
            return YES;
        }
    }
    return NO;
}

- (DeliveryType *)cheapestDelivery {
    if (_deliveryTypes.count == 0) return nil;
    if (_deliveryTypes.count == 1) return _deliveryTypes[0];
    
    DeliveryType *cheapestType = _deliveryTypes[0];
    for (NSInteger i = 1; i < _deliveryTypes.count; i++) {
        DeliveryType *type = _deliveryTypes[i];
        if (![type isScheduledShipping] && type.price.doubleValue < cheapestType.price.doubleValue) {
            cheapestType = type;
        }
    }
    return cheapestType;
}

- (NSDictionary *)selectedDeliveryDictionary {
    ShippingDelivery *shipppingDelivery = self;
    NSArray *cartItems = shipppingDelivery.cartItems;
    NSMutableArray *mutableItemKeys = [NSMutableArray new];
    for (CartItem *cartItem in cartItems)
    {
        [mutableItemKeys addObject:cartItem.key];
    }
    
    NSArray *itemKeys = mutableItemKeys.copy;
    NSString *deliveryTypeId = self.selectedDelivery.deliveryTypeID ?: @"";
    NSNumber *shippingEstimateInDays = self.selectedDelivery.shippingEstimateInDays ?: @0;
    NSString *shippingEstimateTimeUnit = self.selectedDelivery.shippingEstimateTimeUnit ?: @"";
    NSString *sellerID = self.sellerId ?: @"";
    NSNumber *price = ([self.selectedDelivery.priceMap objectForKey:self.selectedDelivery.deliveryTypeID]) ?: [NSNumber numberWithInteger:0];
    NSString *name = self.selectedDelivery.name;
    NSDictionary *deliveryInfo = nil;
    
    if ([self.selectedDelivery isScheduledShipping]) {
        NSDictionary *scheduledDeliveryInfo = [[OFShipmentTemp new] getSelectedShipmentDetails];
        if (scheduledDeliveryInfo)
        {
            NSMutableDictionary *mutableDeliveryInfo = [[NSMutableDictionary alloc] initWithDictionary:scheduledDeliveryInfo];
            [mutableDeliveryInfo setObject:price forKey:@"price"];
            
            deliveryInfo = @{@"deliveryWindow" : mutableDeliveryInfo.copy,
                             @"itemsKeys" : itemKeys,
                             @"deliveryTypeId" : deliveryTypeId,
                             @"sellerId" : sellerID,
                             @"price" : price,
                             @"name" : name,
                             @"shippingEstimateInDays" : shippingEstimateInDays,
                             @"shippingEstimateTimeUnit" : shippingEstimateTimeUnit};
        }
    }
    else
    {
        deliveryInfo = @{@"itemsKeys" : itemKeys,
                         @"deliveryTypeId" : deliveryTypeId,
                         @"sellerId" : sellerID,
                         @"price" : price,
                         @"name" : name,
                         @"shippingEstimateInDays" : shippingEstimateInDays,
                         @"shippingEstimateTimeUnit" : shippingEstimateTimeUnit};
    }
    return deliveryInfo;
}

- (DeliveryType *)scheduledDelivery {
    for (DeliveryType *deliveryType in _deliveryTypes) {
        if ([deliveryType isScheduledShipping]) {
            return deliveryType;
        }
    }
    return nil;
}

@end
