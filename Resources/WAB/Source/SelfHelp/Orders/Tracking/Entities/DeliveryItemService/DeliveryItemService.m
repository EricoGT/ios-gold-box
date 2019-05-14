//
//  DeliveryItemService.m
//  Tracking
//
//  Created by Bruno Delgado on 27/04/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "DeliveryItemService.h"

@implementation DeliveryItemService

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"localizedDescription" : @"description"}];
}

@end
