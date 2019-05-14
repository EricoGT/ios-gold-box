//
//  ExtendedWarrantyDetail.m
//  Walmart
//
//  Created by Bruno Delgado on 5/29/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyDetail.h"

@implementation ExtendedWarrantyDetail

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"descriptionText" : @"description"}];
}

@end
