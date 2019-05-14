//
//  Code.m
//  Walmart
//
//  Created by Bruno Delgado on 2/4/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "Code.h"

@implementation Code

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"codeId" : @"id"}];
}

@end
