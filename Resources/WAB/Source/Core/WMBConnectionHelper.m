//
//  WMBEnvironmentHelper.m
//  Walmart
//
//  Created by Renan Cargnin on 2/13/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBConnectionHelper.h"

@import AirshipKit;
#import <sys/utsname.h>

@implementation WMBConnectionHelper

+ (WMBEnvironment)currentEnvironment {
    #if defined CONFIGURATION_EnterpriseQA || DEBUGQA || CONFIGURATION_TestWm || CONFIGURATION_EnterprisePR || CONFIGURATION_DebugCalabash
    return WMBEnvironmentQA;
    #else
    #if defined CONFIGURATION_Staging
    return WMBEnvironmentStaging;
    #else
    return WMBEnvironmentProduction;
    #endif
    #endif
}

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)device {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)urbanDeviceToken {
    return [[UAirship push] deviceToken];
}

+ (NSString *)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)system {
    return @"iOS";
}

@end
