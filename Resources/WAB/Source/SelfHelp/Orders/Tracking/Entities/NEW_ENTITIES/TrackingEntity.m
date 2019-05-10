//
//  TrackingEntity.m
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingEntity.h"

@implementation TrackingEntity

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orders" : @"simpleOrders"}];
}

@end
