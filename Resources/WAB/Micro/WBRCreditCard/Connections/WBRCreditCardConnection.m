//
//  WBRCreditCardConnection.m
//  Walmart
//
//  Created by Rafael Valim on 27/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCardConnection.h"
#import "ErrorConnectionmanager.h"
#import "WBRCreditCardUrls.h"

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_WALLET YES
#else
#define USE_MOCK_WALLET NO
#endif
// ---------------------------------------------------

@implementation WBRCreditCardConnection

- (void)addUserCreditCard:(WBRModelCreditCard *)creditCard
              withSuccess:(void (^)(NSData *data))success
               andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_WALLET) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wallet-put" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success(jsonData);
    }
    else {
        
        NSDictionary *creditCardDictionary = @{@"completeName"        : creditCard.completeName,
                                               @"brand"               : creditCard.brand,
                                               @"number"              : creditCard.cardNumber,
                                               @"lastDigitsOfCard"    : creditCard.lastDigitsOfCard,
                                               @"expirationDate"      : creditCard.expirationDate,
                                               @"expiryMonth"         : creditCard.expiryMonth,
                                               @"expiryYear"          : creditCard.expiryYear,
                                               @"cvv2"                : creditCard.cvv2,
                                               @"document"            : creditCard.document
                                               };
        NSData *postData = [NSJSONSerialization dataWithJSONObject:creditCardDictionary options:0 error:nil];
        
        NSDictionary *dictParam = @{@"httpMethod"   : @"POST",
                                    @"url"          : URL_WALLET,
                                    @"postData"     : postData};
        
        [self addUserCreditCardWithParams:dictParam withSuccess:^(NSData *data) {
            success(data);
        } andFailure:^(NSError *error, NSData *dataError) {
            failure(error, dataError);
        }];
    }
}

- (void)addUserCreditCardWithParams:(NSDictionary *)dictParam withSuccess:(void (^)(NSData *data))success andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    NSString *strUrl = [dictParam objectForKey:@"url"];
    LogMicro(@"[WALLET] URL: %@", strUrl);
    
    //Header Info
    WMTokens *tkManager = [WMTokens new];
    WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
    NSDictionary *headers;
    if (tkUs.accessToken.length > 0) {
        headers = @{@"token"        : tkUs.accessToken,
                    @"content-type" : @"application/json"};
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:[dictParam objectForKey:@"httpMethod"]];
    [request setAllHTTPHeaderFields:headers];
    LogMicro(@"[WALLET] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[WALLET] Header: %@", headers);
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:[dictParam objectForKey:@"postData"]];
        LogMicro(@"[WALLET] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[WALLET] Status Code: %i", responseStatusCode);
        
        //200
        if (responseStatusCode == 200) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success) {
                    success(data);
                }
            }];
        }
        else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"[WALLET] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.creditcard" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            }];
        }
    }];
    
    [dataTask resume];
}

- (void)deleteUserCreditCard:(WBRModelCreditCard *)creditCard
                 withSuccess:(void (^)(NSData *data))success
                  andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_WALLET) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wallet-delete" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success(jsonData);
    }
    else {
        
        NSString *urlWallet = [NSString stringWithFormat:@"%@/%@", URL_WALLET, creditCard.tokenId];
        NSDictionary *dictParam = @{@"httpMethod"   : @"DELETE",
                                    @"url"          : urlWallet
                                    };
        
        [self sendUserCreditCardOperationWithParams:dictParam withSuccess:^(NSData *data) {
            success(data);
        } andFailure:^(NSError *error, NSData *dataError) {
            failure(error, dataError);
        }];
    }
}

- (void)setDefaultUserCreditCard:(WBRModelCreditCard *)creditCard
                     withSuccess:(void (^)(NSData *data))success
                      andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_WALLET) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wallet-delete" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success(jsonData);
    }
    else {
        
        NSString *urlWallet = [NSString stringWithFormat:@"%@/%@", URL_WALLET, creditCard.tokenId];
        NSDictionary *dictParam = @{@"httpMethod"   : @"PUT",
                                    @"url"          : urlWallet
                                    };
        
        [self sendUserCreditCardOperationWithParams:dictParam withSuccess:^(NSData *data) {
            success(data);
        } andFailure:^(NSError *error, NSData *dataError) {
            failure(error, dataError);
        }];
    }
}

- (void)sendUserCreditCardOperationWithParams:(NSDictionary *)dictParam withSuccess:(void (^)(NSData *data))success andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    NSString *strUrl = [dictParam objectForKey:@"url"];
    LogMicro(@"[WALLET] URL: %@", strUrl);
    
    //Header Info
    WMTokens *tkManager = [WMTokens new];
    WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
    NSDictionary *headers;
    if (tkUs.accessToken.length > 0) {
        headers = @{@"token" : tkUs.accessToken};
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:[dictParam objectForKey:@"httpMethod"]];
    [request setAllHTTPHeaderFields:headers];
    LogMicro(@"[WALLET] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[WALLET] Header: %@", headers);
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:[dictParam objectForKey:@"postData"]];
        LogMicro(@"[WALLET] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[WALLET] Status Code: %i", responseStatusCode);
        
        //200
        if (responseStatusCode == 200) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success) {
                    success(data);
                }
            }];
        }
        else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"[WALLET] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.creditcard" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            }];
        }
    }];
    
    [dataTask resume];
}

- (void)requestUserWalletWithSuccess:(void (^)(WBRModelWallet *userWallet))success
                          andFailure:(void (^)(NSError *error, NSData *data))failure {
    
    if (USE_MOCK_WALLET) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-wallet-get" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Wishlist GET: %@", dictJson);
        
        NSError *parserError;
        WBRModelWallet *userWallet = [[WBRModelWallet alloc] initWithDictionary:dictJson error:&parserError];
        
        if (parserError) {
            failure(parserError, nil);
        }
        else {
            success(userWallet);
        }
    }
    else {
        
        NSDictionary *dictParam = @{@"httpMethod"   : @"GET",
                                    @"url"          : URL_WALLET};
        
        [self requestUserWalletWithParams:dictParam andSuccess:^(WBRModelWallet *userWallet, NSData *data) {
            success(userWallet);
        } andFailure:^(NSError *error, NSData *data) {
            failure(error, data);
        }];
    }
}

- (void)requestUserWalletWithParams:(NSDictionary *)dictParam andSuccess:(void (^)(WBRModelWallet *userWallet, NSData *data))success andFailure:(void (^)(NSError *error, NSData *dataError))failure
{
    NSString *strUrl = [dictParam objectForKey:@"url"];
    LogMicro(@"[WALLET] URL: %@", strUrl);
    
    //Header Info
    WMTokens *tkManager = [WMTokens new];
    WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
    NSDictionary *headers;
    if (tkUs.accessToken.length > 0) {
        headers = @{@"token" : tkUs.accessToken};
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:[dictParam objectForKey:@"httpMethod"]];
    [request setAllHTTPHeaderFields:headers];
    LogMicro(@"[WALLET] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[WALLET] Header: %@", headers);
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:[dictParam objectForKey:@"postData"]];
        LogMicro(@"[WALLET] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[WALLET] Status Code: %i", responseStatusCode);
        
        //200
        if (responseStatusCode == 200) {
            
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            LogInfo(@"[REQUEST] Wishlist: %@", dictJson);
            
            NSError *parserError;
            WBRModelWallet *userWallet = [[WBRModelWallet alloc] initWithDictionary:dictJson error:&parserError];
            
            if (parserError) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (failure) {
                        failure(parserError, data);
                    }
                }];
            }
            else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (success) {
                        success(userWallet, data);
                    }
                }];
            }
        }
        else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"[WALLET] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.creditcard" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            }];
        }
    }];
    
    [dataTask resume];
}
@end
