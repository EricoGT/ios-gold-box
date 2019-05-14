//
//  ServicesMessageModel.m
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ServicesMessageModel.h"

@implementation ServicesMessageModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"messageId" : @"id",
                                                       @"text" : @"message"}];
}

@end
