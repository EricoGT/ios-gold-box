//
//  ExtendedWarrantyConnection.m
//  Walmart
//
//  Created by Renan Cargnin on 5/28/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "ExtendedWarrantyConnection.h"

#import "Reachability.h"
#import "ExtendedWarrantyResumeModel.h"
#import "ExtendedWarrantyDetail.h"
#import "OFLogService.h"
#import "LogError.h"
#import "ExtendedWarrantyCancelData.h"

@implementation ExtendedWarrantyConnection

- (void)loadExtendedWarrantiesWithPageNumber:(NSUInteger)pageNumber completionBlock:(void (^)(NSArray *warranties))success failure:(void (^)(NSError *error))failure {
    NSString *base = [[OFUrls new] getURLExtendedWarrantyList];
    NSString *page = [NSString stringWithFormat:@"?pageNumber=%ld", (long)pageNumber];
    NSString *URLString = [NSString stringWithFormat:@"%@%@",base, page];
    NSURL *url = [NSURL URLWithString:URLString];
    
    LogURL(@"Get extended warranties url: %@", [url description]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        LogInfo(@"Extended warranties response: %@", json);
        NSArray *jsonArray = [json objectForKey:@"warranties"];
        NSMutableArray *warrantiesMutable = [NSMutableArray new];
        for (NSDictionary *warrantyDict in jsonArray)
        {
            NSError *parseError;
            ExtendedWarrantyResumeModel *warrantyResume = [[ExtendedWarrantyResumeModel alloc] initWithDictionary:warrantyDict error:&parseError];
            if (parseError)
            {
                LogError *log = [LogError new];
                log.absolutRequest = url.absoluteString;
                log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
                log.data = [NSKeyedArchiver archivedDataWithRootObject:json];;
                log.userMessage = @"";
                log.screen = @"Extended Warranty Details";
                log.fragment = @"loadExtendedWarrantiesWithPageNumber:";
                [[OFLogService new] sendLog:log];
                
                LogInfo(@"ExtendedWarrantyResumeModel parse error: %@", parseError.localizedDescription);
                continue;
            }
            else
            {
                [warrantiesMutable addObject:warrantyResume];
            }
        }
        if (success) success(warrantiesMutable.copy);
        
    } failure:^(NSError *error, NSData *data) {
        
        LogInfo(@"Extended Warrany Detail - Error (%ld): %@",(long)error.code, error.localizedDescription);
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = REQUEST_ERROR;
        log.screen = @"Extended Warranty Details";
        log.fragment = @"loadExtendedWarrantiesWithPageNumber:";
        [[OFLogService new] sendLog:log];
        
        if (failure) failure([WMBaseConnection errorWithCode:error.code message:REQUEST_ERROR]);
    }];
}

- (void)getExtendedWarrantyDetailForTicketNumber:(NSString *)ticketNumber completionBlock:(void (^)(ExtendedWarrantyDetail *warranty))success failure:(void (^)(NSError *error))failure {
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLExtendedWarrantyList]];
    url = [url URLByAppendingPathComponent:ticketNumber ?: @""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSError *parserError;
        ExtendedWarrantyDetail *warrantyDetail = [[ExtendedWarrantyDetail alloc] initWithDictionary:json error:&parserError];
        if (parserError)
        {
            LogErro(@"Parser error: %@", parserError);
            
            LogError *log = [LogError new];
            log.absolutRequest = url.absoluteString;
            log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
            log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
            log.userMessage = EXTENDED_WARRANTY_DETAIL_PARSER_ERROR;
            log.screen = @"Extended Warranty Details";
            log.fragment = @"getExtendedWarrantyDetailForTicketNumber:";
            [[OFLogService new] sendLog:log];
            
            if (failure) failure([WMBaseConnection errorWithMessage:EXTENDED_WARRANTY_DETAIL_PARSER_ERROR]);
        }
        else
        {
            if (success) success(warrantyDetail);
        }
        
    } failure:^(NSError *error, NSData *data) {
        LogInfo(@"Extended Warrany Detail - Error (%ld): %@",(long)error.code, error.localizedDescription);
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = EXTENDED_WARRANTY_DETAIL_PARSER_ERROR;
        log.screen = @"Extended Warranty Details";
        log.fragment = @"getExtendedWarrantyDetailForTicketNumber:";
        [[OFLogService new] sendLog:log];
        
        if (failure) failure([WMBaseConnection errorWithCode:error.code message:EXTENDED_WARRANTY_DETAIL_PARSER_ERROR]);
    }];
}

- (void)getExtendedWarrantiesCancelOptionsForOrderNumber:(NSNumber *)orderNumber completionBlock:(void (^)(ExtendedWarrantyCancelData *cancelData))success failure:(void (^)(NSError *error))failure {
    NSURL *url = [NSURL URLWithString:[[OFUrls new] getURLExtendedWarrantyCancelOptions]];
    url = [url URLByAppendingPathComponent:orderNumber ? orderNumber.stringValue : @""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
         NSError *parserError;
         ExtendedWarrantyCancelData *cancelData = [[ExtendedWarrantyCancelData alloc] initWithDictionary:json error:&parserError];
         if (parserError)
         {
             LogErro(@"Parser error: %@", parserError);
             
             LogError *log = [LogError new];
             log.absolutRequest = url.absoluteString;
             log.code = [NSString stringWithFormat:@"%li", (long)response.statusCode];
             log.data = [NSKeyedArchiver archivedDataWithRootObject:json];
             log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
             log.screen = @"Cancel Extended Warranty";
             log.fragment = @"getExtendedWarrantiesCancelOptionsForOrderNumber:";
             [[OFLogService new] sendLog:log];
             
             if (failure) failure([WMBaseConnection errorWithMessage:ERROR_CONNECTION_DATA_ERROR_JSON]);
         }
         else
         {
             if (success) success(cancelData);
         }
         
     } failure:^(NSError *error, NSData *data) {
         LogInfo(@"Extended Warranty Cancel - Error (%ld): %@",(long)error.code, error.localizedDescription);
         LogError *log = [LogError new];
         log.absolutRequest = url.absoluteString;
         log.code = [NSString stringWithFormat:@"%li", (long)error.code];
         log.data = data;
         log.userMessage = ERROR_CONNECTION_DATA_ERROR_JSON;
         log.screen = @"Cancel Extended Warranty";
         log.fragment = @"getExtendedWarrantiesCancelOptionsForOrderNumber:";
         [[OFLogService new] sendLog:log];
         
         if (failure) failure([WMBaseConnection errorWithCode:error.code message:ERROR_CONNECTION_DATA_ERROR_JSON]);
     }];
}

- (void)cancelExtendedWarranty:(NSDictionary *)cancelDictionary completionBlock:(void (^)(NSNumber *protocol))success failure:(void (^)(NSError *error))failure {
    NSData *postData = [NSJSONSerialization dataWithJSONObject:cancelDictionary options:0 error:nil];
    NSString *urlString = [[OFUrls new] getURLExtendedWarrantyCancel];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    LogInfo(@"Data Sent: %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    LogInfo(@"Cancel Warranty Info: %@", cancelDictionary);

    [self run:request authenticate:YES completionBlock:^(NSDictionary *json, NSHTTPURLResponse *response) {
        NSNumber *protocolNumber = json[@"id"] ?: @"";
        if (success) success (protocolNumber);
    } failure:^(NSError *error, NSData *data) {
        
        LogInfo(@"Extended Warranty Cancel - Error (%ld): %@",(long)error.code, error.localizedDescription);
        LogError *log = [LogError new];
        log.absolutRequest = url.absoluteString;
        log.code = [NSString stringWithFormat:@"%li", (long)error.code];
        log.data = data;
        log.userMessage = EXTENDED_WARRANTY_CANCEL_ERROR;
        log.screen = @"Cancel Extended Warranty";
        log.fragment = @"cancelExtendedWarranty:";
        [[OFLogService new] sendLog:log];
        
        if (failure) failure([WMBaseConnection errorWithCode:error.code message:EXTENDED_WARRANTY_CANCEL_ERROR]);
    }];
}

@end
