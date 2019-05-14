//
//  WBRContactRequestSubjectModel.m
//  Walmart
//
//  Created by Renan on 6/17/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WBRContactRequestSubjectModel.h"

@implementation WBRContactRequestSubjectModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"subjectId" : @"id"}];
}

@end
