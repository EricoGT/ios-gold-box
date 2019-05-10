//
//  WBRProductConnection.m
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRProductConnection.h"
#import "ErrorConnectionmanager.h"
#import "ProductUrls.h"
#import "WBRUTM.h"
#import "WMBaseConnection.h"

@implementation WBRProductConnection

- (void) requestSearchQuery:(NSString *)query sortParameter:(NSString *)sortParam successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    LogMicro(@"[SEARCH] Query: %@", query);
    LogMicro(@"[SEARCH] SortParameter: %@", sortParam);
    
    BOOL isAutomation = NO;
    
    if ([query rangeOfString:@"ft=automacao"].location != NSNotFound || [query rangeOfString:@"ft=Automacao"].location != NSNotFound || [query rangeOfString:@"ft=Automacao-appium"].location != NSNotFound || [query rangeOfString:@"ft=automacao-appium"].location != NSNotFound || [query rangeOfString:@"&PageNumber"].location != NSNotFound) {
        
        isAutomation = YES;
    }
    
    if (USE_MOCK_SEARCH && isAutomation) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-products-automacao" ofType:@"json"];
        
        if ([query rangeOfString:@"ft=Automacao-appium"].location != NSNotFound || [query rangeOfString:@"ft=automacao-appium"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-products-automacao-appium" ofType:@"json"];
        }
        
        if ([query rangeOfString:@"&PageNumber"].location != NSNotFound) {
            
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-products-empty" ofType:@"json"];
        }

        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Search: %@", dictJson);
        
        //Send to model
        NSError *error = nil;
        
        if (!error) {
            success (jsonData);
        }
        else {
            failure (@{@"error" : ERROR_PARSE_DATABASE});
        }
    }
    else if (USE_MOCK_SEARCH && [query rangeOfString:@"error-mock"].location != NSNotFound) {
        failure (@{@"error" : ERROR_PARSE_DATABASE});
        return;
    }
    else {
        
        NSString *strUrl = URL_SEARCH;
        
        NSString *queryUrl = query;
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *escapedURLString = [queryUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"?fq" withString: @"fq"];
        escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"amp;" withString: @""];
        escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
        escapedURLString = [escapedURLString stringByReplacingOccurrencesOfString: @"%252B" withString: @"+"];

        strUrl = [NSString stringWithFormat:@"%@/%@", strUrl, escapedURLString];
        
        if (sortParam) {
            strUrl = [NSString stringWithFormat:@"%@%@",strUrl, sortParam];
        }
        
        NSDictionary *utmHeader = [WBRUTM addUTMHeaderTo:[NSURL URLWithString:strUrl]];
        
        [self requestSearchContentWithUrl:strUrl customHeader:utmHeader success:^(NSData *data, NSHTTPURLResponse *httpResponse) {
            
            //Transform data from server to NSDictionary
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            LogInfo(@"[REQUEST] Search: %@", dictJson);
            
            success (data);
            
        } failure:^(NSDictionary *dictError) {
            
            failure (@{@"error" : ERROR_PARSE_DATABASE});
            
        }];
        
    }
}

- (void) requestProductDetail:(NSString *)urlProdDetail showcaseId:(NSString *)showcaseId successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    LogMicro(@"[PRODUCT DETAIL] Showcase Id: %@", showcaseId);
    LogMicro(@"[PRODUCT DETAIL] URL Product: %@", urlProdDetail);
    
    if (USE_MOCK_PRODUCT_DETAIL){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail" ofType:@"json"];
        
        if ([urlProdDetail rangeOfString:@"product/2036037"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2036037" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2867119"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2867119" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2137851"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2137851" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2370838"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2370838" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2704652"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2704652" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2019340"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2019340" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2103512"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2103512" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"sku/120398"].location != NSNotFound) { //SKU from productId 2103512
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-120398" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2880215"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2880215" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/2032203"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-2032203" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/3068520"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-3068520" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"product/4481041"].location != NSNotFound) {
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-4481041" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"sku/2981996"].location != NSNotFound ) {//SKU from productId 4481041
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-4481041-sku-2981996" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"sku/2981995"].location != NSNotFound ) {//SKU from productId 4481041
            filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-detail-4481041-sku-2981995" ofType:@"json"];
        }
        else if ([urlProdDetail rangeOfString:@"error-mock"].location != NSNotFound) {
            
            failure (@{@"error" : ERROR_PARSE_DATABASE});
            return;
        }
        
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Product Detail: %@", dictJson);
        
        success (jsonData);
    }
    else {
        
        [self requestProduct:urlProdDetail success:^(NSData *data, NSHTTPURLResponse *httpResponse) {
            
            success (data);
            
        } failure:^(NSDictionary *dictError) {
            
            if (failure) failure (dictError);
        }];
    }
}

- (void) requestProductReviews:(NSString *)urlProdReviews successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure{
    
    LogMicro(@"[PRODUCT REVIEWS] URL Product Reveiws: %@", urlProdReviews);
    
    if (USE_MOCK_PRODUCT_REVIEWS){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-product-reviews" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Product Reviews: %@", dictJson);
        
        success (jsonData);
    }
    else {
        
        [self requestSearchContentWithUrl:urlProdReviews customHeader:nil success:^(NSData *data, NSHTTPURLResponse *httpResponse) {
            
            success (data);
            
        } failure:^(NSDictionary *dictError) {
            
            if (failure) failure (dictError);
        }];
    }
}

- (void) requestPaymentForms:(NSDictionary *) dictProductInfo successBlock:(void (^)(PaymentForms *payment)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    LogMicro(@"[PAYMENT FORMS] Dict Payment Forms Parameters: %@", dictProductInfo);
    
    if (USE_MOCK_PAYMENT_FORMS) {
        
        NSString *strTest = [dictProductInfo objectForKey:@"test"] ?: @{};
        
        if ([strTest rangeOfString:@"error-mock"].location != NSNotFound) {
            
            failure (@{@"error" : ERROR_PARSE_DATABASE});
            return;
        }
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-paymentForms" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Payment Forms: %@", dictJson);
        
        PaymentForms *payment = [[PaymentForms alloc] initWithDictionary:dictJson error:nil];
        
        success (payment);
    }
    else {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@/%@/paymentForms/seller/%@/sellPrice/%@?showBankSlip=true", URL_PRODUCT_PAYMENT_FORMS, [dictProductInfo objectForKey:@"sku"], [dictProductInfo objectForKey:@"sellerId"], [dictProductInfo objectForKey:@"price"]];
        NSString *previousMethod = [self getCallerStackSymbol];
        LogMicro(@"Previous Method: %@", previousMethod);
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        
        NSDictionary *headers = @{
                                  @"cache-control": @"no-cache",
                                  @"versionApp": version,
                                  @"system": @"iOS"
                                  };
        
        NSURL *url = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:strUrl]];
        LogURL(@"URL: %@", [url absoluteString]);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeoutRequest];
        
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        LogMicro(@"[PAYMENT FORMS] Header: %@", headers);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                //Transform data from server to NSDictionary
                NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                LogInfo(@"[REQUEST] Payment Forms: %@", dictJson);
            }
            
            NSError *paymentsParserError;
            PaymentForms *payment = [[PaymentForms alloc] initWithData:data error:&paymentsParserError];
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
            LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
            
            //200 201 and 204
            BOOL statusCodeValid = NO;
            if (responseStatusCode == 200) {
                statusCodeValid = YES;
            }
            if (error || !statusCodeValid) {
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                
                LogMicro(@"[%@] DictError: %@", previousMethod, dictError);
                
                if (failure) failure (dictError);
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (responseStatusCode)
                        if (success) success(payment);
                });
            }
        }];
        
        [dataTask resume];
    }
}

- (void) requestWarrantyProductDetail:(NSString *)sku sellerId:(NSString *) sellerId sellPrice:(NSNumber *) sellPrice successBlock:(void (^)(NSData *jsonData)) success failure:(void (^) (NSDictionary *dictError)) failure {
    
    LogMicro(@"[WARRANTY] SKU Product: %@", sku);
    
    if (USE_MOCK_PRODUCT_WARRANTY){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-warranty" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        //Transform data from server to NSDictionary
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        LogInfo(@"[REQUEST MOCK] Warranty Product Detail: %@", dictJson);
        
        if ([sku rangeOfString:@"error-mock"].location != NSNotFound) {
            
            failure (@{@"error" : ERROR_PARSE_DATABASE});
            return;
        }
        
        success (jsonData);
    }
    else {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@/%@/warranties/seller/%@/sellPrice/%@", URL_PRODUCT_EXTENDED_WARRANTY, sku, sellerId, sellPrice];
        NSString *previousMethod = [self getCallerStackSymbol];
        LogMicro(@"Previous Method: %@", previousMethod);
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        
        NSDictionary *headers = @{
                                  @"cache-control": @"no-cache",
                                  @"versionApp": version,
                                  @"system": @"iOS"
                                  };
        
        NSURL *url = [NSURL URLWithString:strUrl];
        url = [WBRUTM addUTMQueryParameterTo:url];
        
        LogURL(@"URL: %@", url.absoluteString);
        
        LogInfo(@"[EXTENDED WARRANTY] sellerId: %@", sellerId);
        LogInfo(@"[EXTENDED WARRANTY] sellPrice: %@", sellPrice);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeoutRequest];
        
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        LogMicro(@"[EXTENDED WARRANTY] Header: %@", headers);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                //Transform data from server to NSDictionary
                NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                LogInfo(@"[REQUEST] Extended Warranty: %@", dictJson);
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            //        LogMicro(@"httpResponse: %@", httpResponse);
            int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
            LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
            
            //200 201 and 204
            BOOL statusCodeValid = NO;
            if (responseStatusCode == 200) {
                statusCodeValid = YES;
            }
            if (error || !statusCodeValid) {
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                
                LogMicro(@"[%@] DictError: %@", previousMethod, dictError);
                
                if (failure) failure (dictError);
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (responseStatusCode)
                        if (success) success(data);
                });
            }
        }];
        
        [dataTask resume];
    }
}


- (void) requestProduct:(NSString *) strUrl success:(void (^)(NSData *data, NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure {
    
    NSString *previousMethod = [self getCallerStackSymbol];
    LogMicro(@"Previous Method: %@", previousMethod);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
    
    NSDictionary *headers = @{
                              @"cache-control": @"no-cache",
                              @"versionApp": version,
                              @"system": @"iOS"
                              };
    
    NSURL *requestURL = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:strUrl]];
    
    LogURL(@"URL: %@", requestURL.absoluteString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    LogMicro(@"[PRODUCT] Header: %@", headers);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            //Transform data from server to NSDictionary
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            LogInfo(@"[REQUEST] Product: %@", dictJson);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        //        LogMicro(@"httpResponse: %@", httpResponse);
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
        
        //200 201 and 204
        BOOL statusCodeValid = NO;
        if (responseStatusCode == 200) {
            statusCodeValid = YES;
        }
        if (error || !statusCodeValid) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                
                LogMicro(@"[%@] DictError: %@", previousMethod, dictError);
                
                if (failure) failure (dictError);
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseStatusCode)
                    if (success) success(data, httpResponse);
            });
        }
    }];
    
    [dataTask resume];
}


- (void)requestSearchContentWithUrl:(NSString *) strUrl customHeader:(NSDictionary *)customHeader success:(void (^)(NSData *data, NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure {
    
    NSString *previousMethod = [self getCallerStackSymbol];
    LogMicro(@"Previous Method: %@", previousMethod);
    
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                     @"cache-control": @"no-cache",
                                                                                     @"versionApp": version,
                                                                                     @"system": @"iOS"
                                                                                     }];
    
    if (customHeader != nil) {
        for (NSString *headerKey in [customHeader allKeys]) {
            [headers setObject:customHeader[headerKey] forKey:headerKey];
        }
    }
    
    NSURL *url = [WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:strUrl]];
    LogURL(@"URL: %@", url.absoluteString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    if (!request.allHTTPHeaderFields[@"token"])
    {
        WMTokens *tkManager = [WMTokens new];
        WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
        if (tkUs.accessToken.length > 0)
        {
            //[tkManager refreshTokenInBackground:tkUs];
            [request setValue:tkUs.accessToken forHTTPHeaderField:@"token"];
        }
    }

    LogMicro(@"[SEARCH] Header: %@", headers);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            //Transform data from server to NSDictionary
            NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            LogInfo(@"[REQUEST SEARCH] Product: %@", dictJson);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        //        LogMicro(@"httpResponse: %@", httpResponse);
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[%@] Status Code: %i", previousMethod, responseStatusCode);
        
        //200 201 and 204
        BOOL statusCodeValid = NO;
        if (responseStatusCode == 200) {
            statusCodeValid = YES;
        }
        if (error || !statusCodeValid) {
            
            NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
            
            LogMicro(@"[%@] DictError: %@", previousMethod, dictError);
            
            if (failure) failure (dictError);
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (responseStatusCode)
                    if (success) success(data, httpResponse);
            });
        }
    }];
    
    [dataTask resume];
}

- (void)sendProductReview:(WBRModelSendReview *)productReview
            withProductId:(NSString *)productId
             successBlock:(kProductConnectionSuccessBlock) success
                  failure:(kProductConnectionFailureBlock) failure {
    
    NSString *strUrl = [[OFUrls new] getUrlPostProductReviewWithProductId:productId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    NSDictionary *productReviewDict = [productReview toDictionary];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:productReviewDict options:0 error:nil];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    LogMicro(@"[REVIEW] URL: %@", strUrl);
    LogMicro(@"[REVIEW] HTTPMethod: POST");
    LogMicro(@"[WALLET] HTTPBody: %@", productReviewDict);
    
    [[WMBaseConnection new] run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        
        LogInfo(@"sendProductReview:withProductId:successBlock:failure: %@", json);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(json);
            }
        }];
    } failure:^(NSError *error, NSData *data) {
        
        LogInfo(@"sendProductReview:withProductId:successBlock:failure: %@", error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSDictionary *errorDictionary = @{@"errorMessage": REVIEW_EVALUATION_FAILURE,
                                              @"errorCode": @(error.code)};
            
            LogMicro(@"[WALLET] DictError: %@", errorDictionary);
            
            if (failure) {
                failure(errorDictionary);
            }
        }];
    }];
}

- (void)postProductReviewEvaluation:(NSString *)reviewURL evaluation:(NSNumber *)evaluation successBlock:(kProductConnectionSuccessBlock)success failure:(kProductConnectionFailureBlock)failure {
    
    NSURL *url = [NSURL URLWithString:reviewURL];
    LogURL(@"Post product review evaluation: %@", [url description]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *dictionary = @{@"isRevelant": evaluation};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];

    [request setHTTPBody:bodyData];
    
    [[WMBaseConnection new] run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        
        LogInfo(@"postProductReviewEvaluation: evaluation: successBlock: failure: %@", json);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(json);
            }
        }];
    } failure:^(NSError *error, NSData *data) {
        
        LogInfo(@"postProductReviewEvaluation: evaluation: successBlock: failure: %@", error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSDictionary *errorDictionary = @{@"errorMessage": REVIEW_EVALUATION_FAILURE};
            
            if (failure) {
                failure(errorDictionary);
            }
        }];
    }];
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
