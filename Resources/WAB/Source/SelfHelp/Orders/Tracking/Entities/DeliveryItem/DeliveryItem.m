//
//  DeliveryItem.m
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "DeliveryItem.h"

@implementation DeliveryItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"services" : @"deliveryItemServices"}];
}

@end
