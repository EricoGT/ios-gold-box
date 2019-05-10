//
//  WBRConnection.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/14/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRConnection.h"

#import "NSError+CustomError.h"

static NSString *kRestAPIMethodGET      = @"GET";
static NSString *kRestAPIMethodPOST     = @"POST";
static NSString *kRestAPIMethodPUT      = @"PUT";
static NSString *kRestAPIMethodDELETE   = @"DELETE";

@interface WBRConnection()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation WBRConnection

+ (instancetype)sharedInstance {
    static WBRConnection *sharedInstance = nil;
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfiguration.timeoutIntervalForRequest = 30;
            sharedInstance.session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        }
    }
    
    return sharedInstance;
}

#pragma mark - Methods

#pragma mark GET

- (void)GET:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self GET:path headers:nil authenticationLevel:kAuthenticationLevelNotRequired successBlock:successBlock failureBlock:failureBlock];
}

- (void)GET:(NSString *)path headers:(NSDictionary<NSString *,NSString *> *)headers authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self runRequestWithMethod:kRestAPIMethodGET withPath:path withHeaders:headers withBody:nil authenticationLevel:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark POST

- (void)POST:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self POST:path headers:nil body:nil authenticationLevel:kAuthenticationLevelNotRequired successBlock:successBlock failureBlock:failureBlock];
}

- (void)POST:(NSString *)path headers:(NSDictionary<NSString *,NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self runRequestWithMethod:kRestAPIMethodPOST withPath:path withHeaders:headers withBody:body authenticationLevel:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

- (void)POST:(NSString *)path headers:(NSDictionary<NSString *,NSString *> *)headers bodyString:(NSString *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self runRequestWithMethod:kRestAPIMethodPOST withPath:path withHeaders:headers withBodyString:body authenticationLevel:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark PUT

- (void)PUT:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self PUT:path headers:nil body:nil authenticationLevel:kAuthenticationLevelNotRequired successBlock:successBlock failureBlock:failureBlock];
}

- (void)PUT:(NSString *)path headers:(NSDictionary<NSString *,NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self runRequestWithMethod:kRestAPIMethodPUT withPath:path withHeaders:headers withBody:body authenticationLevel:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark DELETE

- (void)DELETE:(NSString *)path successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self DELETE:path headers:nil body:nil authenticationLevel:kAuthenticationLevelNotRequired successBlock:successBlock failureBlock:failureBlock];
}

- (void)DELETE:(NSString *)path headers:(NSDictionary<NSString *,NSString *> *)headers body:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self runRequestWithMethod:kRestAPIMethodDELETE withPath:path withHeaders:headers withBody:body authenticationLevel:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Run Request

- (void)runRequest:(NSMutableURLRequest *)request authenticated:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock{
    
    if (authenticationLevel == kAuthenticationLevelNotRequired) {
        [self runRequest:request successBlock:successBlock failureBlock:failureBlock];
    }
    else {
        [[WMTokens new] getTokenOAuth:^(NSString *token) {
           
            if (token.length == 0 && authenticationLevel == kAuthenticationLevelRequired) {
                NSError *customError = [NSError errorWithCode:401 message:ERROR_CONNECTION_DATA_ERROR_JSON];
                if (failureBlock) failureBlock(customError, nil);
            }
            else {
                if (token.length > 0) {
                    [request setValue:token forHTTPHeaderField:@"token"];
                }
                [self runRequest:request successBlock:successBlock failureBlock:failureBlock];
            }
        }];
    }
}

- (void)runRequestWithMethod:(NSString *)method withPath:(NSString *)path withHeaders:(NSDictionary <NSString *, NSString *> *)headers withBody:(NSDictionary *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    NSMutableURLRequest *request = [self requestWithMethod:method withPath:path withHeaders:headers withBody:body];
    [self runRequest:request authenticated:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

- (void)runRequestWithMethod:(NSString *)method withPath:(NSString *)path withHeaders:(NSDictionary <NSString *, NSString *> *)headers withBodyString:(NSString *)body authenticationLevel:(kAuthenticationLevel)authenticationLevel successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    NSMutableURLRequest *request = [self requestWithMethod:method withPath:path withHeaders:headers withBodyString:body];
    [self runRequest:request authenticated:authenticationLevel successBlock:successBlock failureBlock:failureBlock];
}

- (void)runRequest:(NSURLRequest *)request successBlock:(kConnectionSuccessBlock)successBlock failureBlock:(kConnectionFailureBlock)failureBlock {
    
    [self logRequest:request];
    [self showNetworkActivityIndicator:YES];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self showNetworkActivityIndicator:NO];
        [self logResponseWithData:data response:response error:error];
        
        NSInteger statusCode = [[self handleError:error withResponse:response] integerValue];
        
        [self logServerTimeWithResponse:response];
        
        if (error == nil && statusCode == 200) {
            if (successBlock) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    successBlock(response, data);
                }];
            }
        }
        else {
            NSString *errorMessage;
            switch (statusCode) {
                case 408:
                    errorMessage = ERROR_CONNECTION_TIMEOUT;
                    break;
                    
                case 1009:
                    errorMessage = ERROR_CONNECTION_INTERNET;
                    break;
                    
                default:
                    errorMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
                    break;
            }
            NSError *customError = [NSError errorWithCode:statusCode message:errorMessage];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                if (statusCode == 401) {
                    [[WALMenuViewController singleton] logoutAndShowHome:NO];
                }
                
                if (failureBlock) {
                    failureBlock(customError, data);
                }
            }];
        }
        
    }] resume];
}

- (void)runRawRequest:(NSURLRequest *)request completionBlock:(kConnectionRawBlock)completionBlock {
    
    [self logRequest:request];
    [self showNetworkActivityIndicator:YES];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self showNetworkActivityIndicator:NO];
        [self logResponseWithData:data response:response error:error];
        [self logServerTimeWithResponse:response];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (completionBlock) {
                completionBlock(response, data, error);
            }
        }];
    }] resume];
}

#pragma mark - Error Handler

- (NSNumber *)handleError:(NSError *)error withResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSNumber *statusCode = @(httpResponse.statusCode);
    
    if (error.code == -1012) {
        statusCode = @401;
    }
    else if (error.code == -1001) {
        statusCode = @408;
    }
    else if (error.code == -1003 ||
             error.code == -1004 ||
             error.code == -1005 ||
             error.code == -1009) {
        statusCode = @1009;
    }
    
    return statusCode;
}

#pragma mark - Request Build Methods

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method withPath:(NSString *)path withHeaders:(NSDictionary <NSString *, NSString *> *)headers withBody:(NSDictionary *)body {
    
    NSMutableURLRequest *request = [self createRequestWithURL:path method:method];
    request = [self addHeaders:headers toRequest:request];
    request = [self addDictionaryBody:body toRequest:request];
    
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method withPath:(NSString *)path withHeaders:(NSDictionary <NSString *, NSString *> *)headers withBodyString:(NSString *)body {
    
    NSMutableURLRequest *request = [self createRequestWithURL:path method:method];
    request = [self addHeaders:headers toRequest:request];
    
    if (body && ![body isEqualToString:@""]) {
        request.HTTPBody = [body dataUsingEncoding:kCFStringEncodingUTF8];
    }
    
    return request;
}

- (NSMutableURLRequest *)createRequestWithURL:(NSString *)path method:(NSString *)method {
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    
    return request;
}

- (NSMutableURLRequest *)addHeaders:(NSDictionary <NSString *, NSString *> *)headers toRequest:(NSMutableURLRequest *)request {
    for (NSString *headerKey in headers.allKeys) {
        [request setValue:headers[headerKey] forHTTPHeaderField:headerKey];
    }
    
    return request;
}

- (NSMutableURLRequest *)addDictionaryBody:(NSDictionary *)body toRequest:(NSMutableURLRequest *)request {
    
    if (body) {
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:0 error:nil]];
    }
    
    return request;
}

#pragma mark - Log

- (void)logServerTimeWithResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headers = httpResponse.allHeaderFields;
    if ([headers objectForKey:@"Date"] != nil) {
        NSString *date = [headers objectForKey:@"Date"];
        [WMBSession updateServerDateWithStringDate:date];
    }
}


- (void)logRequest:(NSURLRequest *)request {
    LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Method: \n%@", request.HTTPMethod);
    LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: HTTP headers:\n%@", request.allHTTPHeaderFields);
    
    if (request.HTTPBody) {
        LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Body: \n%@", [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:0 error:nil]);
    }
}

- (void)logResponseWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    
    if (data) {
        NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Completion Data: \n%@", file);
    }
    else {
        LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Completion Data: nil");
    }
    
    LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Completion Response \n%@", response);
    LogInfo(@"[WBRConnection] runRequest:successBlock:failureBlock: Completion Error \n%@", error);
}

#pragma mark - UI

- (void)showNetworkActivityIndicator:(BOOL)shouldShow {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = shouldShow;
    }];
}

@end
