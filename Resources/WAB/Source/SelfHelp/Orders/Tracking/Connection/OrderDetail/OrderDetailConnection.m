//
//  OrderDetailConnection.m
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "OrderDetailConnection.h"
#import "UserSession.h"
#import "OFMessages.h"
#import "WMTokens.h"
#import "OFSetup.h"

//#define timeoutRequest 50.0f

@implementation OrderDetailConnection

+ (instancetype)sharedInstance
{
    static OrderDetailConnection *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)getDetailsFromOrder:(Order *)order completionBlock:(void (^)(TrackingOrderDetail *details))success failureBlock:(void (^)(NSError *error))failure
{
    OFMessages *messages = [OFMessages new];
    OFUrls *urls = [OFUrls new];
    
    NSString *formattedPath = [NSString stringWithFormat:@"%@/%@",[urls getURLOrdersDetail], order.orderId];
    NSURL *url = [NSURL URLWithString:formattedPath];
    LogURL(@"URL getDetailsFromOrder: %@", url);
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSError *parseError = nil;
        TrackingOrderDetail *tracking = [[TrackingOrderDetail alloc] initWithDictionary:json error:&parseError];
        
        if (parseError)
        {
            [FlurryWM logTracking_event_account_err:@{@"response_code"  :   @(99),
                                                      @"error"          :   parseError,
                                                      @"screen"         :   @"OrdersDetailViewController",
                                                      @"method"         :   @"getDetailsFromOrder"}];
            if (failure) failure([NSError errorWithDomain:@"com.tracking.walmart" code:99 userInfo:@{NSLocalizedDescriptionKey : [messages errorOrderStatusDetail]}]);
        }
        else
        {
            if (success) success(tracking);
        }
    } failure:^(NSError *error, NSData *data) {
        [FlurryWM logTracking_event_account_err:@{@"response_code"  :   @(error.code),
                                                  @"error"          :   error.localizedDescription,
                                                  @"screen"         :   @"OrdersDetailViewController",
                                                  @"method"         :   @"getDetailsFromOrder"}];
        
        NSString *msgError = [messages errorOrders];
        if (error.code == 408) {
            msgError = ERROR_CONNECTION_TIMEOUT;
        }
        if (failure) failure([NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : msgError}]);
    }];
}

@end
