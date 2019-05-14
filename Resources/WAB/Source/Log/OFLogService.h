//
//  OFLogService.h
//  Walmart
//
//  Created by Marcelo Santos on 12/16/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogError.h"

@interface OFLogService : NSObject

@property (nonatomic, strong) NSArray *arrLogs;
@property (nonatomic, strong) NSDictionary *dictLog;
@property BOOL shouldSendLog;

- (void) sendLogsWithErrorEvent:(NSString *) errorEvent andRequestUrl:(NSString *) requestUrl andRequestData:(NSString *) requestData andResponseCode:(NSString *) responseCode andResponseData:(NSString *) responseData andUserMessage:(NSString *) userMessage andScreen:(NSString *) screen andFragment:(NSString *) fragment;
- (void)sendLog:(LogError *)log;

@end
