//
//  TrackingTimelineSubItem.m
//  Walmart
//
//  Created by Bruno Delgado on 10/17/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingTimelineSubItem.h"

@implementation TrackingTimelineSubItem

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"descriptionText" : @"description"}];
}

@end
