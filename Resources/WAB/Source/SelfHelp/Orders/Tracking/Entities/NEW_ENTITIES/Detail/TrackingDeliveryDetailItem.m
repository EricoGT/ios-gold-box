//
//  TrackingDeliveryDetailItem.m
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingDeliveryDetailItem.h"

@implementation TrackingDeliveryDetailItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"itemID" : @"id",
                                                                  @"itemDescription" : @"description"}];
}

@end
