//
//  WBRShipmentConnection.m
//  Walmart
//
//  Created by Murilo Alves Alborghette on 8/24/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRShipmentConnection.h"

#import "ErrorConnectionmanager.h"
#import "TimeManager.h"
#import "WBRShipmentUrls.h"
#import "WMTokens.h"

@implementation WBRShipmentConnection

- (void) requestDeleteShipment:(ModelCheckoutDelivery *)delivery success:(void (^)(void))success failure:(void (^)(NSError *error, NSData *dataError))failure {
        
    LogURL(@"URL: %@", URL_SHIPMENT);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
    WMTokens *tokens = [[WMTokens alloc] init];
    
    NSDictionary *headers = @{
                              @"content-type": @"application/json",
                              @"cache-control": @"no-cache",
                              @"version": version,
                              @"system": @"iOS",
                              @"token": [tokens getTokenCheckout],
                              @"cart": [tokens getCartId]
                              };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_SHIPMENT]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody: [[delivery toJSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    LogMicro(@"[WBRSetupConnection] Header: %@", headers);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        [TimeManager updateServerDateWithResponse:httpResponse];
        
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        
        LogMicro(@"httpResponse: %@", httpResponse);
        
        //200 201 and 204
        BOOL statusCodeValid = NO;
        if (responseStatusCode == 200) {
            statusCodeValid = YES;
        }
        if (error || !statusCodeValid) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"requestDeleteShipment - DictError: %@", dictError);
                if (failure) {
                    failure(error, nil);
                }
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseStatusCode && success) {
                    success();
                }
            });
        }
    }];
    
    [dataTask resume];
}

@end
