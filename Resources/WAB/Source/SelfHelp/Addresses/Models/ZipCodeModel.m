//
//  ZipCodeModel.m
//  Walmart
//
//  Created by Renan on 5/25/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ZipCodeModel.h"

@implementation ZipCodeModel

- (NSString *)completeStreetName
{
    NSString *fullName = @"";
    
    if (self.streetType.length > 0)
    {
        fullName = [fullName stringByAppendingString:self.streetType];
        fullName = [fullName stringByAppendingString:@" "];
    }
    
    if (self.street.length > 0)
    {
        fullName = [fullName stringByAppendingString:self.street];
    }
    
    return fullName;
}

@end
