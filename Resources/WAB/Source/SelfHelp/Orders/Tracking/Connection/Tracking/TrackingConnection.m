//
//  OrderConnection.m
//  Tracking
//
//  Created by Bruno Delgado on 4/17/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

#import "TrackingConnection.h"
#import "UserSession.h"
#import "OFMessages.h"
#import "WMTokens.h"
#import "TrackingEntity.h"
#import "OFSetup.h"

//#define timeoutRequest 50.0f

@implementation TrackingConnection

+ (instancetype)sharedInstance
{
    static TrackingConnection *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)getTrackingInformationFromCurrentUserWithCompletionBlock:(void (^)(TrackingEntity *trackingInfo))success failureBlock:(void (^)(NSError *error))failure
{
    OFMessages *messages = [OFMessages new];
    OFUrls *urls = [OFUrls new];
    UserSession *session = [UserSession sharedInstance];
    NSNumber *page = (session.currentPage != nil) ? session.currentPage : @0;
    
    NSString *ordersURL = [urls getURLOrders];
    ordersURL = [ordersURL stringByAppendingFormat:@"?pageNumber=%ld", (long)page.integerValue];
    ordersURL = [ordersURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:ordersURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    
    LogURL(@"URL getTrackingInformation: %@", request.URL);
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSError *parseError;
        TrackingEntity *tracking = [[TrackingEntity alloc] initWithDictionary:json error:&parseError];
        
        if (parseError)
        {
            [FlurryWM logTracking_event_account_err:@{@"response_code"  :   @(99),
                                                      @"error"          :   parseError,
                                                      @"screen"         :   @"OrderListViewController",
                                                      @"method"         :   NSStringFromSelector(@selector(getTrackingInformationFromCurrentUserWithCompletionBlock:failureBlock:))}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure(parseError);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(tracking);
            });
        }
    } failure:^(NSError *error, NSData *data) {
        [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long) error.code],
                                   @"message"      :   [NSString stringWithFormat:@"%@", error.localizedDescription],
                                   @"method"       :   @"runRequest:",
                                   @"screen"       :   @"Your Account"}];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:url.absoluteString andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long) error.code] ?: @""
                                   andResponseData:[NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]] andUserMessage:@"" andScreen:@"Your Account" andFragment:NSStringFromSelector(@selector(getTrackingInformationFromCurrentUserWithCompletionBlock:failureBlock:))];
        
        if (error.code == 404)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) success(nil);
            });
        }
        else
        {
            [FlurryWM logTracking_event_account_err:@{@"response_code"  :   @(error.code),
                                                      @"error"          :   error.localizedDescription,
                                                      @"screen"         :   @"OrderListViewController",
                                                      @"method"         :   @"getTrackingInformationFromCurrentUser"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) failure([NSError errorWithDomain:error.domain ?: @"" code:error.code userInfo:@{NSLocalizedDescriptionKey : [messages errorOrders]}]);
            });
        }
    }];
}

@end
