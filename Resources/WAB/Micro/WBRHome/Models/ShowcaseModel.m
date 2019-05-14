//
//  ShowcaseModel.m
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "ShowcaseModel.h"

@implementation ShowcaseModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"showcaseId" : @"id",
                                                                  @"products": @"shelfItems"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    return [propertyName isEqualToString:@"isRefreshing"] || [propertyName isEqualToString:@"dynamic"];
}

@end
