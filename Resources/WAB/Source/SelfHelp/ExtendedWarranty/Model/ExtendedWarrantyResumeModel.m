//
//  ExtendedWarrantyResumeModel.m
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyResumeModel.h"

@implementation ExtendedWarrantyResumeModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"descriptionText":@"description"}];
}

@end
