//
//  TrackingOrderDetail.m
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingOrderDetail.h"

@implementation TrackingOrderDetail

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderID" : @"id"}];
}

@end
