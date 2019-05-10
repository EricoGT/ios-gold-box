//
//  WMUTMIManager.h
//  Walmart
//
//  Created by Bruno Delgado on 10/15/15.
//  Copyright © 2015 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTMIModel.h"

static NSString * const kUTMIStored = @"UTMIStored";

@interface WMUTMIManager : NSObject

#pragma mark - Add
+ (void)storeUTMI:(UTMIModel *)model;

#pragma mark - Retrieve
+ (UTMIModel *)UTMI;

#pragma mark - Clean
+ (void)clean;

@end
