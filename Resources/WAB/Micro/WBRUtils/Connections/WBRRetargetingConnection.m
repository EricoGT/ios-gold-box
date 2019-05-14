//
//  WBRRetargetingConnection.m
//  Walmart
//
//  Created by Marcelo Santos on 6/6/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRRetargetingConnection.h"
#import "WBRUser.h"
#import "ErrorConnectionmanager.h"

@implementation WBRRetargetingConnection

- (void) requestRetargShowcases:(NSString *) strUrl success:(void (^)(NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure {
    
    
    if (USE_MOCK_RETARGETING) {
        
        if ([strUrl isEqualToString:@""]) {
            
            NSHTTPURLResponse *httpResponseMock = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@""] statusCode:200 HTTPVersion:@"" headerFields:@{}];
            success(httpResponseMock);
        }
        else {
            
            NSDictionary *dictErrorMock = @{@"error" : ERROR_PARSE_DATABASE};
            failure (dictErrorMock);
        }
    }
    else
    {
        NSString *pidUser = [WBRUser pid];
        
        if (pidUser) {
            strUrl = [NSString stringWithFormat:@"%@&Pid=%@", strUrl, pidUser];
        }
        
        NSString *previousMethod = [self getCallerStackSymbol];
        LogRtg(@"[RETARGETING] Previous Method: %@", previousMethod);
        LogURL(@"[RETARGETING] URL: %@", strUrl);
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        
        NSDictionary *headers = @{
                                  @"cache-control": @"no-cache",
                                  @"versionApp": version,
                                  @"system": @"iOS"
                                  };
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeoutRequest];
        
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        LogRtg(@"[RETARGETING] Header: %@", headers);
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
            LogRtg(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
            
            //200 201 and 204
            BOOL statusCodeValid = NO;
            if (responseStatusCode == 200) {
                statusCodeValid = YES;
            }
            if (error || !statusCodeValid) {
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                
                LogRtg(@"[%@] DictError: %@", previousMethod, dictError);
                
                if (failure) failure (dictError);
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (responseStatusCode)
                        if (success) success(httpResponse);
                });
            }
        }];
        
        [dataTask resume];
    }
}

- (NSString *)getCallerStackSymbol {
    
    NSString *callerStackSymbol = @"Could not track caller stack symbol";
    
    NSArray *stackSymbols = [NSThread callStackSymbols];
    if(stackSymbols.count >= 2) {
        callerStackSymbol = [stackSymbols objectAtIndex:2];
        if(callerStackSymbol) {
            NSMutableArray *callerStackSymbolDetailsArr = [[NSMutableArray alloc] initWithArray:[callerStackSymbol componentsSeparatedByString:@" "]];
            NSUInteger callerStackSymbolIndex = callerStackSymbolDetailsArr.count - 3;
            if (callerStackSymbolDetailsArr.count > callerStackSymbolIndex && [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex]) {
                callerStackSymbol = [callerStackSymbolDetailsArr objectAtIndex:callerStackSymbolIndex];
                callerStackSymbol = [callerStackSymbol stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }
        }
    }
    
    return callerStackSymbol;
}

@end
