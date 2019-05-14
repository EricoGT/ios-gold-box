//
//  Order.m
//  Tracking
//
//  Created by Bruno Delgado on 4/17/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "Order.h"
#import "JsonValueTransformer.h"

@implementation Order

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId" : @"id",
                                                                  @"invoice" : @"payment"}];
}

@end
