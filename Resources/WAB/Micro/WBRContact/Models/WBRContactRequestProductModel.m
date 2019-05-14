//
//  WBRContactRequestProductModel.m
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestProductModel.h"

@implementation WBRContactRequestProductModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"productId" : @"id",
                                                       @"descriptionText" : @"description"}];
}

@end
