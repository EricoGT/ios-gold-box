//
//  TrackingOrderItem.m
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingOrderItem.h"

@implementation TrackingOrderItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderItemId" : @"id",
                                                                  @"orderItemDescription" : @"description"}];
}

@end
