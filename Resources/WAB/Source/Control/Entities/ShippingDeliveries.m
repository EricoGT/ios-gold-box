//
//  ShippingDelivery.m
//  Walmart
//
//  Created by Bruno Delgado on 6/2/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "ShippingDeliveries.h"

@implementation ShippingDeliveries

- (instancetype)initWithString:(NSString *)string error:(JSONModelError *__autoreleasing *)err {
    self = [super initWithString:string error:err];
    if (self) {
        for (ShippingDelivery *delivery in _deliveries) {
            for (DeliveryType *type in delivery.deliveryTypes) {
                type.priceMap = delivery.deliveryTypePriceMap;
            }
        }
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"totalPrice" : @"cart.totalPrice"}];
}

@end
