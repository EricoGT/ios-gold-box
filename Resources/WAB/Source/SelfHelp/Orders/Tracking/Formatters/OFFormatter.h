//
//  OFFormatter.h
//  Walmart
//
//  Created by Bruno Delgado on 5/19/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFFormatter : NSObject

+ (instancetype)sharedInstance;
- (NSNumberFormatter *)currencyFormatter;

@end
