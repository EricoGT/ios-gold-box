//
//  WBRContactTicketConnection.m
//  Walmart
//
//  Created by Rafael Valim dos Santos on 15/03/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRTicketManager.h"
#import "WBRContactTicketUrls.h"
#import "ErrorConnectionmanager.h"
#import "WBRConnection.h"

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_TICKETS YES
#else
#define USE_MOCK_TICKETS NO
#endif
// ---------------------------------------------------

@implementation WBRTicketManager

+ (void)getUserTicketsForPageNumber:(NSNumber *)pageNumber
                            withSuccess:(void (^)(NSArray<WBRModelTicket *> *ticketCollection))success
                             andFailure:(void (^)(NSError *error, NSData *data))failure {
    
    if (USE_MOCK_TICKETS) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ticketList" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        NSMutableArray *tickets = [[NSMutableArray alloc] init];
        LogInfo(@"[REQUEST MOCK] TicketsCollection GET: %@", jsonArray);

        __block NSError *parserError;
        
        [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            WBRModelTicket *modelTicket = [[WBRModelTicket alloc] initWithDictionary:obj error:&parserError];
            if (!parserError) {
                [tickets addObject:modelTicket];
            } else {
                parserError = error;
            }
        }];

        
        if (parserError) {
            failure(parserError, nil);
        }
        else {
            success(tickets);
        }
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@?page=%@&sorted_by=desc", URL_TICKET_HUB_LIST, [pageNumber stringValue]];
        
        NSDictionary *dictParam = @{@"httpMethod"   : @"GET",
                                    @"url"          : urlString};
        [self requestUserTicketsWithParams:dictParam andSuccess:^(NSArray<WBRModelTicket *> *userTicketCollection, NSData *data) {
            success(userTicketCollection);

        } andFailure:^(NSError *error, NSData *dataError) {
            failure(error, dataError);
        }];
    }
}

+ (void)requestUserTicketsWithParams:(NSDictionary *)dictParam andSuccess:(void (^)(NSArray<WBRModelTicket*> *userTicketCollection, NSData *data))success andFailure:(void (^)(NSError *error, NSData *dataError))failure
{
    NSString *strUrl = [dictParam objectForKey:@"url"];
    LogMicro(@"[TICKETS] URL: %@", strUrl);
    
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
    LogMicro(@"[TICKETS] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[TICKETS] Header: %@", headers);
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:[dictParam objectForKey:@"postData"]];
        LogMicro(@"[TICKETS] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[TICKETS] Status Code: %i", responseStatusCode);

        if (responseStatusCode == 200) {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            NSMutableArray *tickets = [[NSMutableArray alloc] init];
            __block NSError *parserError;

            [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSError *error;
                NSDictionary *dict = (NSDictionary *)obj;
                WBRModelTicket *modelTicket = [[WBRModelTicket alloc] initWithDictionary:dict error:&parserError];
                if (!parserError) {
                    [tickets addObject:modelTicket];
                } else {
                    parserError = error;
                }
            }];
            LogInfo(@"[REQUEST] Tickets: %@", tickets);
            if (parserError) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (failure) {
                        failure(parserError, data);
                    }
                }];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (success) {
                        success(tickets, data);
                    }
                }];
            }
        } else if (responseStatusCode == 404) {
            //When server returns 404, there is no tickets on that pageNumber
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success) {
                    NSMutableArray *tickets = [[NSMutableArray alloc] init];
                    success(tickets, data);
                }
            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSDictionary *dictError = [ErrorConnectionmanager analyzeResponse:httpResponse error:error];
                LogMicro(@"[TICKETS] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.userTickets" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            }];
        }
    }];
    
    [dataTask resume];
}

+ (void)reopenUserTicketWithTicketId:(NSString *)ticketId
                      andDescription:(NSString *)userDescription
                         withSuccess:(void (^)(NSData *data))success
                          andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    if (USE_MOCK_TICKETS) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"reopenTicket" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success(jsonData);
    } else {
        NSString *url = [NSString stringWithFormat:URL_TICKET_HUB_REOPEN, ticketId];
        NSDictionary *reopenInfo = @{@"ticketNumber" : ticketId, @"comment" : userDescription};
        
        [self reopenTicketWithId:reopenInfo andUrl:url withSuccess:^(NSData *data) {
            if (success) {
                success(data);
            }
        } andFailure:^(NSError *error, NSData *dataError) {
            if (failure) {
                failure(error, dataError);
            }
        }];
    }
}

+ (void)reopenTicketWithId:(NSDictionary *)ticketInfo andUrl:(NSString *)url withSuccess:(void (^)(NSData *data))success
                      andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    LogURL(@"[TICKET REOPEN] Url: %@", url);
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    [headerDict setValue:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
    [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
    
    LogMicro(@"[TICKET REOPEN] Headers %@", headerDict);
    LogMicro(@"[TICKET REOPEN] Body %@", ticketInfo);
    
    [[WBRConnection sharedInstance] PUT:url headers:headerDict body:ticketInfo authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(data);
            }
        }];
    } failureBlock:^(NSError *error, NSData *failureData) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            LogMicro(@"[TICKETS REOPEN] Error: %@", error);
            LogMicro(@"[TICKETS REOPEN] Failure Data: %@", failureData);
            NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.userTickets" code:error.code userInfo:@{NSLocalizedDescriptionKey : error.description}];
            failure (errorUnknown, failureData);
        }];
    }];
}

+ (void)closeUserTicketWithTicketId:(NSString *)ticketId
                     andDescription:(NSString *)userDescription
                        withSuccess:(void (^)(NSData *))success
                         andFailure:(void (^)(NSError *, NSData *))failure{
    
    if (USE_MOCK_TICKETS) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock-ticket-close" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        
        success(jsonData);
    } else {
        NSDictionary *postData = @{@"status"   : @"cancel",
                                   @"comment" : userDescription};
        
        ///// change the URL
        NSString *urlString = [NSString stringWithFormat:URL_CONTACT_TICKET_CANCEL, ticketId];
        
        NSDictionary *dictParam = @{@"httpMethod"   : @"PUT",
                                    @"url"          : urlString,
                                    @"postData"     : postData
                                    };
        
        [self closeUserTicketOperationWithParams:dictParam withSuccess:^(NSData *data) {
            success(data);
        } andFailure:^(NSError *error, NSData *dataError) {
            failure(error, dataError);
        }];
    }
}

+ (void)closeUserTicketOperationWithParams:(NSDictionary *)dictParam
                                withSuccess:(void (^)(NSData *data))success
                                 andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    NSString *strUrl = [dictParam objectForKey:@"url"];
    LogMicro(@"[TICKETS REOPEN] URL: %@", strUrl);
    
    //Header Info
    WMTokens *tkManager = [WMTokens new];
    WMBTokenModel *tkUs = [tkManager getTokenOAuthWithoutRefreshToken];
    NSDictionary *headers;
    if (tkUs.accessToken.length > 0) {
        headers = @{@"token" : tkUs.accessToken,
                    @"Content-Type": @"application/json;charset=UTF-8"};
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeoutRequest];
    
    [request setHTTPMethod:[dictParam objectForKey:@"httpMethod"]];
    [request setAllHTTPHeaderFields:headers];
    
    LogMicro(@"[TICKETS REOPEN] HTTPMethod: %@", [dictParam objectForKey:@"httpMethod"]);
    LogMicro(@"[TICKETS REOPEN] Header: %@", headers);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[dictParam objectForKey:@"postData"] options:0 error:nil];
    
    //Verify by body content
    if ([dictParam objectForKey:@"postData"]) {
        [request setHTTPBody:postData];
        LogMicro(@"[TICKETS REOPEN] HTTPBody: %@", [dictParam objectForKey:@"postData"]);
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseStatusCode = (int)[httpResponse statusCode] ?: 0;
        LogMicro(@"[TICKETS REOPEN] Status Code: %i", responseStatusCode);
        
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
                LogMicro(@"[TICKETS REOPEN] DictError: %@", dictError);
                
                NSError *errorUnknown = [[NSError alloc] initWithDomain:@"com.walmart.userTickets" code:[[dictError objectForKey:@"statusCode"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictError objectForKey:@"message"]}];
                
                failure (errorUnknown, data);
            }];
        }
    }];
    
    [dataTask resume];
}


@end
