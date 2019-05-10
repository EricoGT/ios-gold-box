//
//  SortOptions.m
//  Walmart
//
//  Created by Danilo on 9/8/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "SortOption.h"

@implementation SortOption

- (SortOption *)initWithName:(NSString *)name urlParameter:(NSString *)urlParameter
{
    self = [super init];
    if (self)
    {
        _name = name;
        _urlParameter = urlParameter;
    }
    return self;
}

@end
