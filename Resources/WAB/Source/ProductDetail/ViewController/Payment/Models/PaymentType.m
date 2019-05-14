//
//  PaymentType.m
//  Walmart
//
//  Created by Danilo Soares Aliberti on 8/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "PaymentType.h"

@implementation PaymentType

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id":@"id"}];
}

@end
