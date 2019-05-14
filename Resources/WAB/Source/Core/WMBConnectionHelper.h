//
//  WMBEnvironmentHelper.h
//  Walmart
//
//  Created by Renan Cargnin on 2/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMBEnvironmentEnum.h"

static NSString * const deviceIdHeaderName = @"deviceId";
static NSString * const versionHeaderName = @"version";
static NSString * const systemHeaderName = @"system";

@interface WMBConnectionHelper : NSObject

+ (WMBEnvironment)currentEnvironment;

+ (NSString *)deviceId;
+ (NSString *)device;
+ (NSString *)urbanDeviceToken;
+ (NSString *)version;
+ (NSString *)system;

@end
