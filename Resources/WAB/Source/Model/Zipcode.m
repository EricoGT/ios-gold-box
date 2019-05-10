//
//  Zipcode.m
//  Walmart
//
//  Created by Renan Cargnin on 29/12/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "Zipcode.h"

@implementation Zipcode

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"zipcodeId": @"id"}];
}

@end
