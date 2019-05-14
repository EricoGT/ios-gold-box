//
//  TrackingTimelineItem.m
//  Walmart
//
//  Created by Bruno Delgado on 10/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingTimelineItem.h"

@implementation TrackingTimelineItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"message" : @"description"}];
}

@end
