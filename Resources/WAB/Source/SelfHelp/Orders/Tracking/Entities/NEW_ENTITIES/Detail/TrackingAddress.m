//
//  TrackingAddress.m
//  Walmart
//
//  Created by Bruno Delgado on 10/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "TrackingAddress.h"

@implementation TrackingAddress

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"defaultAddress" : @"default"}];
}

@end
