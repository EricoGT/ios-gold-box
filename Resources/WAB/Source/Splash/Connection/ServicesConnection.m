//
//  ServicesConnection.m
//  Walmart
//
//  Created by Renan Cargnin on 8/24/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ServicesConnection.h"

@implementation ServicesConnection

- (void)loadServicesWithCompletionBlock:(void (^)(ServicesModel *))success failure:(void (^)(NSError *))failure {
    NSURL *url = [OFUrls urlWithAppVersion:2 pathComponents:@[@"services"]];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"iOS" forHTTPHeaderField:@"system"];
    [request setValue:version forHTTPHeaderField:@"versionapp"];
    
    [self run:request authenticate:NO completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSError *parserError;
        ServicesModel *services = [[ServicesModel alloc] initWithDictionary:json error:&parserError];
        
        if (services && !parserError) {
            if (success) success(services);
        }
        else {
            LogError *log = [LogError new];
            log.absolutRequest = url.absoluteString;
            log.code = [NSString stringWithFormat:@"%ld", (long)parserError.code];
            log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
            log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
            log.screen = @"Splash";
            log.fragment = NSStringFromSelector(@selector(loadServicesWithCompletionBlock:failure:));
            [[OFLogService new] sendLog:log];
            
            if (failure) failure([self errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
        }
        
    } failure:^(NSError *error, NSData *data) {
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%ld", (long)error.code];
        log.data = [NSKeyedArchiver archivedDataWithRootObject:data];
        log.userMessage = error.localizedDescription;
        log.screen = @"Splash";
        log.fragment = NSStringFromSelector(@selector(loadServicesWithCompletionBlock:failure:));
        [[OFLogService new] sendLog:log];
        
        if (failure) failure(error);
    }];
}

@end
