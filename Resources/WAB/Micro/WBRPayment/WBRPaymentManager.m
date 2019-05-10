//
//  WBRPaymentManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 27/06/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRPaymentManager.h"
#import "WBRConnection.h"
#import "OFLogService.h"
#import "WBRUTM.h"
#import "NSError+CustomError.h"

@implementation WBRPaymentManager

+ (NSDictionary *) authData {
    
    //Get all values
    NSMutableDictionary *authStatus = [[NSMutableDictionary alloc] init];
    [authStatus setValue:[[WMTokens new] getTokenCheckout] forKey:@"tkCk"];
    [authStatus setValue:[[WMTokens new] getCartId] forKey:@"cart"];
    
    return [NSDictionary dictionaryWithDictionary:authStatus];
}

+ (void) verifyIfUpdateCartAndToken:(NSDictionary *) header {
    //Verify and update cart id and token
    LogNewCheck(@"[WMConnectionNewCheckout - verifyByNewToken] header: %@", header);
    if ([header objectForKey:@"cart"]) {
        [[WMTokens new] addCartId:[header objectForKey:@"cart"]];
    }
    if ([header objectForKey:@"token"]) {
        [[WMTokens new] addTokenCheckout:[header objectForKey:@"token"]];
    }
}

+ (void)postPaymentWithCart:(NSString *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock {
    NSString *strJson = jsonBody;
    NSString *url = URL_PAYMENT_WITH_CART;
    url = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:url]].absoluteString;

    NSString *operation = @"selectDeliveryPaymentWithCompleteCart";
    LogNewCheck(@"Operation: %@", operation);
    NSDictionary *dictAuthStatus = [self authData];
    LogNewCheck(@"[WMConnectionNewCheckout - requestPaymentWithUrl] Status Auth: %@", dictAuthStatus);
    NSString *tokenCheckout = [dictAuthStatus objectForKey:@"tkCk"] ?: @"";
    LogNewCheck(@"Str Json Payment [%@]: %@", operation, strJson);
    
    if ([tokenCheckout isEqualToString:@""]) {
        LogErro(@"Invalid new token from checkout (%@)!", operation);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [FlurryWM logEvent_error:@{@"response_code":    @"TOKEN MISSED",
                                       @"message"      :    @"TOKEN MISSED",
                                       @"method"       :    [NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", url] andRequestData:@"" andResponseCode:@"" andResponseData:@"TOKEN MISSED" andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:[NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]];
            
            NSError *error = [NSError errorWithCode:1111 message:@""];
            error = [self getPaymentErrorWithError:error];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }
    
    LogURL(@"[WMConnectionNewCheckout - requestPaymentWithUrl] URL [%@]: %@", operation, url);
    
    BOOL internetTest = [InternetTest internetOk];
    
    if (internetTest) {
        LogNewCheck(@"Token Payment [%@]: %@", operation, tokenCheckout);
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        //Set values for header
        [headerDict setValue:tokenCheckout forKey:@"token"];
        
        NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [[WBRConnection sharedInstance] POST:url headers:headerDict body:jsonBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            LogNewCheck(@"File Payment [%@]: %@", operation, file);
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            
            if (successBlock) {
                successBlock(file);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            if (failureBlock) {
                error = [self getPaymentErrorWithError:error];
                failureBlock(error, file);
            }

        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   [NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]}];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", url] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WBRPaymentManager" andFragment:@"requestPaymentWithUrl:"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self getPaymentErrorWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (void)postPaymentInstallments:(NSString *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock {
    NSString *operation = @"installments";
    NSString *strJson = jsonBody;

    NSString *url = URL_PAYMENT_INSTALLMENTS;
    url = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:url]].absoluteString;
    
    
    LogNewCheck(@"Operation: %@", operation);
    
    NSDictionary *dictAuthStatus = [self authData];
    LogNewCheck(@"[WMConnectionNewCheckout - requestPaymentWithUrl] Status Auth: %@", dictAuthStatus);
    
    NSString *tokenCheckout = [dictAuthStatus objectForKey:@"tkCk"] ?: @"";
    
    LogNewCheck(@"Str Json Payment [%@]: %@", operation, strJson);
    
    if ([tokenCheckout isEqualToString:@""]) {
        
        LogErro(@"Invalid new token from checkout (%@)!", operation);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [FlurryWM logEvent_error:@{@"response_code":    @"TOKEN MISSED",
                                       @"message"      :    @"TOKEN MISSED",
                                       @"method"       :    [NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", url] andRequestData:@"" andResponseCode:@"" andResponseData:@"TOKEN MISSED" andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:[NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]];
            
            NSError *error = [NSError errorWithCode:1111 message:@""];
            error = [self getPaymentErrorWithError:error];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }
    
    LogURL(@"[WMConnectionNewCheckout - requestPaymentWithUrl] URL [%@]: %@", operation, url);
    
    BOOL internetTest = [InternetTest internetOk];
    
    if (internetTest) {
        
        LogNewCheck(@"Token Payment [%@]: %@", operation, tokenCheckout);
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        //Set values for header
        [headerDict setValue:tokenCheckout forKey:@"token"];
        
        NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [[WBRConnection sharedInstance] POST:url headers:headerDict body:jsonBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            LogNewCheck(@"File Payment [%@]: %@", operation, file);
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            
            if (successBlock) {
                successBlock(file);
            }

        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            
            
            if (failureBlock) {
                error = [self getPaymentErrorWithError:error];
                failureBlock(error, file);
            }
        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   [NSString stringWithFormat:@"requestPaymentWithUrl: [%@]", operation]}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", url] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"requestPaymentWithUrl:"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self getPaymentErrorWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (void)postPaymentPlaceOrder:(NSDictionary *)jsonBody successBlock:(kPaymentManagerSuccessStringBlock)successBlock failure:(kPaymentManagerFailureStringBlock)failureBlock {
    
    NSDictionary *dictAuthStatus = [self authData];
    LogNewCheck(@"[WMConnectionNewCheckout - paymentPlaceOrder] Status Auth: %@", dictAuthStatus);
    
    NSString *placeOrderURL = URL_PLACE_ORDER;
    NSURL *url = [NSURL URLWithString:placeOrderURL];
    NSString *urlString = [WBRUTM addUTMQueryParameterTo:url].absoluteString;
    
    LogURL(@"[WMConnectionNewCheckout - paymentPlaceOrder] URL: %@", [url absoluteString]);
    
    NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"] ?: @"";
    
    NSString *strJson = [jsonBody objectForKey:@"placeorder"];
    LogNewCheck(@"Str Json Place Order: %@", strJson);
    
    if ([tkCk isEqualToString:@""]) {
        
        LogErro(@"Invalid new token from checkout (place order)!");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FlurryWM logEvent_error:@{@"response_code":    @"TOKEN MISSED",
                                       @"message"      :    @"TOKEN MISSED",
                                       @"method"       :    @"paymentPlaceOrder:"}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:@"TOKEN MISSED" andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:@"paymentPlaceOrder:"];

            NSError *error = [NSError errorWithCode:1111 message:@""];
            error = [self getPaymentErrorWithError:error];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }
    BOOL internetTest = [InternetTest internetOk];
    
    if (internetTest) {
        LogNewCheck(@"Token Place Order: %@", tkCk);
        LogNewCheck(@"Json String request: %@", strJson);
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        [headerDict setValue:tkCk forKey:@"token"];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        NSData *data = [strJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [[WBRConnection sharedInstance] POST:urlString headers:headerDict body:jsonBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            LogNewCheck(@"File Payment: %@", file);
            LogNewCheck(@".x.x.x.x.x.x.x.x.x.x.x.x..x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x");
            if (successBlock) {
                successBlock(file);
            }

        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            error = [self getPaymentErrorWithError:error];
            if (failureBlock) {
                failureBlock(error, file);
            }

        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"paymentPlaceOrder:"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"paymentPlaceOrder:"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self getPaymentErrorWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (NSError *)getPaymentErrorWithError:(NSError *)error {
    if (error.code == 401) {
        LogErro(@"401 received! Token expired Place Order! :(");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INVALID_DATA];
    } else if (error.code == 408) {
        LogErro(@"Time Out Cart!");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_TIMEOUT];
    } else if (error.code == 0) {
        LogErro(@"Unknown!");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_DATA];
    } else if (error.code == 1009) {
        LogErro(@"Error 1009");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INTERNET];
    } else if (error.code == 1111) {
        LogErro(@"Error 1111 - is pre-connection error");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_INVALID_DATA];
    } else {
        LogErro(@"Erro Place Order!");
        error = [NSError errorWithCode:error.code message:ERROR_CONNECTION_UNKNOWN];
    }
    return error;
}


@end
