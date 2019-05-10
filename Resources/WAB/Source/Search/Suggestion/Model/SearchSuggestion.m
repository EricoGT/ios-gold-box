//
//  SearchSuggestion.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 7/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SearchSuggestion.h"

@implementation SearchSuggestion

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"suggestions" : @"terms"}];
}

@end
