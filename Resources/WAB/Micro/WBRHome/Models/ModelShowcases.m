//
//  ModelShowcases.m
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ModelShowcases.h"

@implementation ModelShowcases

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"idShowcase" : @"id"}];
}

@end