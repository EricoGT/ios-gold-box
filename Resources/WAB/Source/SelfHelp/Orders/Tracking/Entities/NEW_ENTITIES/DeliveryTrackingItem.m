//
//  DeliveryTrackingItem.m
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "DeliveryTrackingItem.h"

@implementation DeliveryTrackingItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"itemDescription" : @"description"}];
}

@end
