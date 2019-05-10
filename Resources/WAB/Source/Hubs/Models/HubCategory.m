//
//  HubCategory.m
//  Walmart
//
//  Created by Renan on 2/5/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "HubCategory.h"

@implementation HubCategory

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"imageURL" : @"image",
                                                                  @"searchParameter" : @"url"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"useHub"])
    {
        return YES;
    }
    return NO;
}

@end
