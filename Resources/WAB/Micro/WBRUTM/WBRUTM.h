//
//  WBRUTM.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 10/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBRUTMModel.h"

static NSString * const kUTMKeychainSource = @"kUTMSource";
static NSString * const kUTMKeychainMedium = @"kUTMMedium";
static NSString * const kUTMKeychainCampaign = @"kUTMCampaign";

@interface WBRUTM : NSObject

+ (void)handleDeepLink:(NSString *)deepLinkURL;
+ (void)updateHourIfNeeded:(NSDate *)newDate;
+ (BOOL)invalidateUTMs;
+ (NSURL *)addUTMQueryParameterTo:(NSURL *)url;
+ (NSDictionary *)addUTMHeaderTo:(NSURL *)url;
+ (NSString *)urlWithoutUTMParameters:(NSString *)url;
+ (WBRUTMModel *)getUTMForKey:(NSString *)key;

@end
