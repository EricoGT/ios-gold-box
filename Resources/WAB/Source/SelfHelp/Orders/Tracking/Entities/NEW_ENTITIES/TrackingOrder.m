//
//  TrackingOrder.m
//  Walmart
//
//  Created by Bruno Delgado on 10/6/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingOrder.h"

@implementation TrackingOrder

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId" : @"id",
                                                                  @"items" : @"items.items"}];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return ([propertyName isEqualToString:@"conciergeDelayed"]);
}

@end
