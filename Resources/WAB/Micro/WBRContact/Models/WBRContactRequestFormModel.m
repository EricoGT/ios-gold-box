//
//  WBRContactRequestFormModel.m
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestFormModel.h"

@implementation WBRContactRequestFormModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"requestTypes" : @"items"}];
}

@end
