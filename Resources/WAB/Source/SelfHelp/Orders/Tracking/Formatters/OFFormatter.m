//
//  OFFormatter.m
//  Walmart
//
//  Created by Bruno Delgado on 5/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFFormatter.h"

@interface OFFormatter ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end

@implementation OFFormatter

+ (instancetype)sharedInstance
{
    static OFFormatter *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (NSNumberFormatter *)currencyFormatter
{
    if (!self.formatter)
    {
        self.formatter = [[NSNumberFormatter alloc] init];
        [self.formatter setCurrencyCode:@"R$ "];
        [self.formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    
    return self.formatter;
}



@end
