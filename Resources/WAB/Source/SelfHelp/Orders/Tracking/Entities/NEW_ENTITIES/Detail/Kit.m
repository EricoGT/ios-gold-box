//
//  Kit.m
//  Walmart
//
//  Created by Bruno Delgado on 5/7/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "Kit.h"

@implementation Kit

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"kitID" : @"id",
                                                                  @"descriptionText" : @"description"}];
}


@end
