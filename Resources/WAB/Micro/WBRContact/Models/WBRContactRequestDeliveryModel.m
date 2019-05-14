//
//  WBRContactRequestDeliveryModel.m
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestDeliveryModel.h"

@implementation WBRContactRequestDeliveryModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"deliveryId" : @"id",
                                                                  @"products" : @"items"}];
}

@end
