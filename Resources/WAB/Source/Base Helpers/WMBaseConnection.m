//
//  WMBaseConnection.m
//  Walmart
//
//  Created by Bruno on 6/11/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "WMBaseConnection.h"
#import "Reachability.h"
#import "OFUrls.h"
#import "OFMessages.h"

#import "WBRConnection.h"

static BOOL forceErrorMock;

@interface WMBaseConnection ()

@property (nonatomic, strong) NSOperationQueue *connectionQueu;

@end

@implementation WMBaseConnection

- (void)run:(NSMutableURLRequest *)request authenticate:(BOOL)authenticate completionBlock:(void (^)(NSDictionary *json, NSHTTPURLResponse *response))success failure:(void (^)(NSError *error, NSData *data))failure {
    if (self.forceFailure && failure) {
        failure([WMBaseConnection errorWithMessage:REQUEST_ERROR], nil);
    }

    if (self.useMock && self.currentMockJSONStr.length > 0) {
        NSData *data = [self.currentMockJSONStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *parserError;
        NSDictionary *jsonMockDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parserError];
        if (!parserError) {
            if (success) success(jsonMockDict, nil);
            return;
        }
    }
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [request setValue:[dictInfo objectForKey:@"system"] forHTTPHeaderField:@"system"];
    [request setValue:[dictInfo objectForKey:@"version"] forHTTPHeaderField:@"version"];

    if (!request.allHTTPHeaderFields[@"deviceid"]) {
        NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (deviceId.length > 0) {
            [request setValue:deviceId forHTTPHeaderField:@"deviceid"];
            LogInfo(@"header deviceId: %@", deviceId);
        }
    }

    if (!request.allHTTPHeaderFields[@"token"] && authenticate) {
        [self trivialConnection:request success:success failure:failure];
    }
    else {
        if ([WALSession isAuthenticated]) {
            [[WMTokens new] getTokenOAuth:^(NSString *token) {
                 if (token.length > 0 && request.allHTTPHeaderFields[@"token"] == nil) {
                     [request setValue:token ?: @"" forHTTPHeaderField:@"token"];
                 }
                 
                 [self PRIVATE_run:request completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
                     if (success) success(json, response);
                 } failure:^(NSError *error, NSData *data) {
                     
                     if (!data) {
                         data = [NSData new];
                     }
                     
                     if (failure ) failure (error, data);
                 }];
             }];
        }
        else {
            [self PRIVATE_run:request completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
                if (success) success(json, response);
            } failure:^(NSError *error, NSData *data) {
                
                if (!data) {
                    data = [NSData new];
                }
                
                if (failure ) failure (error, data);
                
            }];
        }
    }
}

- (void)trivialConnection:(NSMutableURLRequest *)request success:(void (^)(NSDictionary *json, NSHTTPURLResponse *response)) success failure:(void (^)(NSError *error, NSData *data))failure {
    [[WMTokens new] getTokenOAuth:^(NSString *token) {
        NSString *tkUs = token;
        if (tkUs.length > 0) {
            if (request.allHTTPHeaderFields[@"token"] == nil) {
                [request setValue:tkUs ?: @"" forHTTPHeaderField:@"token"];
            }

            [self PRIVATE_run:request completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
                if (success) success(json, response);
            } failure:^(NSError *error, NSData *data) {
                
                if (!data) {
                    data = [NSData new];
                }
                
                if (failure ) failure (error, data);
            }];
        }
        else {
            NSError *error = [self errorWithCode:401 message:ERROR_CONNECTION_DATA_ERROR_JSON];
            if (failure ) failure (error, nil);
        }
     }];
}

- (void)PRIVATE_run:(NSMutableURLRequest *)request completionBlock:(void (^)(NSDictionary *json, NSHTTPURLResponse *response))success failure:(void (^)(NSError *error, NSData *data))failure
{
    LogURL(@"Request URL: %@", request.URL.absoluteString);
    LogInfo(@"Request Headers: %@", request.allHTTPHeaderFields);
    LogInfo(@"Request Body: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);

    BOOL isActiveConnection = [WMBaseConnection hasInternetConnection];

    if (isActiveConnection) {
        
        [[WBRConnection sharedInstance] runRawRequest:request completionBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogInfo(@"Response: %@", file);

            // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [aResponse statusCode];

            NSDictionary *headers = aResponse.allHeaderFields;
            NSString *date = [headers objectForKey:@"Date"];
            [WMBSession updateServerDateWithStringDate:date];

            NSString *errorString = error.description ?: @"";
            if ([errorString rangeOfString:@"Code=-1012"].location != NSNotFound)
            {
                statusCode = 401;
            }
            else if ([errorString rangeOfString:@"Code=-1001"].location != NSNotFound)
            {
                statusCode = 408;
            }
            else if ([errorString rangeOfString:@"Code=-1003"].location != NSNotFound ||
                     [errorString rangeOfString:@"Code=-1004"].location != NSNotFound ||
                     [errorString rangeOfString:@"Code=-1005"].location != NSNotFound ||
                     [errorString rangeOfString:@"Code=-1009"].location != NSNotFound)
            {
                statusCode = 1009;
            }

            if ((data.length) > 0 && (error == nil))
            {
                if (statusCode == 200)
                {
                    NSError *parserError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parserError];
                    if (!parserError)
                    {
                        LogInfo(@"%@ - Response JSON: %@", NSStringFromClass([self class]), json);
                        if (success) success(json, aResponse);
                    }
                    else
                    {
                        LogInfo(@"%@ - JSON ParserError: %@", NSStringFromClass([self class]), parserError.localizedDescription);
                        error = [WMBaseConnection errorWithCode:statusCode message:ERROR_CONNECTION_DATA_ERROR_JSON];
                        if (failure) failure(error,data);
                    }
                }
                else
                {
                    LogInfo(@"%@ - Response status code: %ld", NSStringFromClass([self class]), (long)statusCode);
                    error = [WMBaseConnection errorWithCode:statusCode message:ERROR_CONNECTION_DATA_ERROR_JSON];
                    if (failure) failure(error,data);
                }
            }
            else
            {
                LogInfo(@"%@ - Response status code: %ld", NSStringFromClass([self class]), (long)statusCode);
                switch (statusCode) {
                    case 408:
                        error = [WMBaseConnection errorWithCode:statusCode message:ERROR_CONNECTION_TIMEOUT];
                        break;

                    case 1009:
                        error = [WMBaseConnection errorWithCode:statusCode message:ERROR_CONNECTION_INTERNET];
                        break;

                    default:
                        error = [WMBaseConnection errorWithCode:statusCode message:ERROR_CONNECTION_DATA_ERROR_JSON];
                        break;
                }
                if (failure) failure(error, data);
            }

            if (statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[WALMenuViewController singleton] logoutAndShowHome:NO];
                });
            }
        }];
    }
    else
    {
        if (failure) failure([WMBaseConnection errorWithCode:1009 message:ERROR_CONNECTION_INTERNET], nil);
    }
}

#pragma mark - Internet Check
+ (BOOL)hasInternetConnection
{
    Reachability *reachabilityInstance = [Reachability reachabilityForInternetConnection];
    [reachabilityInstance startNotifier];
    
    NetworkStatus status = [reachabilityInstance currentReachabilityStatus];
    return status != NotReachable;
}

#pragma mark - Error
- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [WMBaseConnection errorWithCode:code message:message];
}

- (NSError *)errorWithMessage:(NSString *)message
{
    return [WMBaseConnection errorWithMessage:message];
}

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:@"com.Walmart" code:code userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

+ (NSError *)errorWithMessage:(NSString *)message
{
    return [NSError errorWithDomain:@"com.Walmart" code:0 userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

#pragma mark - Queue
- (NSOperationQueue *)connectionQueu
{
    if (!_connectionQueu) _connectionQueu = [NSOperationQueue new];
    return _connectionQueu;
}

+ (BOOL)forceErrorMock
{
    return forceErrorMock;
}

+ (void)setForceErrorMock:(BOOL)forceError
{
    forceErrorMock = forceError;
}

@end
