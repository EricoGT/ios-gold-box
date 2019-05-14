//
//  ModelSplash.m
//  Walmart
//
//  Created by Marcelo Santos on 3/9/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "ModelSplash.h"

@implementation ModelSplash

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"idSplash" : @"id"}];
}

@end
