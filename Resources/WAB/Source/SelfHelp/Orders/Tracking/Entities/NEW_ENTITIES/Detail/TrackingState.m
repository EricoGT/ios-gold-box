//
//  TrackingState.m
//  Walmart
//
//  Created by Bruno Delgado on 10/10/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingState.h"

@implementation TrackingState

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"stateID" : @"id"}];
}

@end
