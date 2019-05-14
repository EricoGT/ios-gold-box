//
//  WBRContactRequestOrderModel.m
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestOrderModel.h"

@implementation WBRContactRequestOrderModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"orderId" : @"id"}];
}

@end
