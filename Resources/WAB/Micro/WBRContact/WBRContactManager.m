//
//  WBRContactManager.m
//  Walmart
//
//  Created by Diego Batista Dias Leite on 21/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRContactManager.h"
#import "WBRConnection.h"
#import "NSError+CustomError.h"
#import "WBRContactManagerUrls.h"

// MOCK Control---------------------------------------
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
    #define USE_MOCK_CONTACT YES
#else
    #define USE_MOCK_CONTACT NO
#endif
// ---------------------------------------------------
//
// Files: /walmart-app-mocks/contact/*.json
#define kSubjectsFile          @"subjects"
#define kOrderList             @"orderList"
#define kOrderListWarranty     @"ordersWithWarranty"
#define kOrderListNotCancelled @"ordersNotCancelled"
#define kDeliveriesList        @"deliveries"
#define kExchangeList          @"genericFields"
#define kBankList              @"banks"
#define kOrderDetail           @"order"
#define kOpenTicket            @"sendContactFormSuccess"
// ---------------------------------------------------

@implementation WBRContactManager

+ (void)getContactSubjectsWithAuthentication:(BOOL)authentication success:(kContactManagerSubjectsSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getContactSubjectsWithAuthentication");
        NSString *filePath = [[NSBundle mainBundle] pathForResource:kSubjectsFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        WBRContactRequestFormModel *form = [[WBRContactRequestFormModel alloc] initWithDictionary:json error:&parseError];
        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getContactSubjectsWithAuthentication Response Parsed: %@", form);
            successBlock(form);
        } else {
            LogErro(@"[CONTACT] MOCK - getContactSubjectsWithAuthentication ERROR Parser: %@", parseError.description);
            if (failureBlock) {
                failureBlock(parseError);
            }
        }
    } else {
        NSString *url = [WBRContactManagerUrls urlContactTicketSubjects];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };
        LogURL(@"[CONTACT] URL: %@",url);
        LogMicro(@"[CONTACT] Header: %@", headerDict);

        kAuthenticationLevel authenticationLevel = authentication ? kAuthenticationLevelRequired : kAuthenticationLevelNotRequired;
        
        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:authenticationLevel successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *parserError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            WBRContactRequestFormModel *form = [[WBRContactRequestFormModel alloc] initWithDictionary:json error:&parserError];
            if (parserError) {
                LogErro(@"[CONTACT] Subjects Parser error: %@", data);
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            } else {
                LogMicro(@"[CONTACT] Subjects Response Success: %@", json);
                if (successBlock) {
                    successBlock(form);
                }
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSError *errorResponse = [NSError errorWithCode:error.code message:CONTACT_REQUEST_REQUEST_ERROR];
            if (error.code == 401) {
                errorResponse = [NSError errorWithCode:error.code message:ERROR_UNKNOWN_AUTH];
            }
            LogErro(@"[CONTACT] Subjects error: %@", errorResponse);
            LogErro(@"[CONTACT] Subjects failure data: %@", failureData);

            if (failureBlock) {
                failureBlock(errorResponse);
            }
        }];
    }
}

+ (void)getOrdersWithExtendWarranty:(BOOL)extendWarranty andFilterByNotCancelled:(BOOL)notCancelledOrders success:(kContactManagerOrdersSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getOrdersWithExtendWarranty");
        NSString *mockFile = kOrderList;
        if (extendWarranty) {
            mockFile = kOrderListWarranty;
        } else if (notCancelledOrders) {
            mockFile = kOrderListNotCancelled;
        }
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        WBRContactRequestOrdersArrayModel *orders = [[WBRContactRequestOrdersArrayModel alloc] initWithDictionary:json error:&parseError];
        
        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getOrdersWithExtendWarranty Response Parsed: %@", orders);
            successBlock(orders);
        } else {
            LogErro(@"[CONTACT] MOCK - getOrdersWithExtendWarranty ERROR Parser: %@", parseError.description);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }
    } else {
        NSString *url = [WBRContactManagerUrls urlContactRequestOrders];
        
        if (notCancelledOrders) {
            url = [OFUrls addQueryParameterToURL:url queryParameter:@"notCancelled" value:notCancelledOrders];
        }
        if (extendWarranty) {
            url = [OFUrls addQueryParameterToURL:url queryParameter:@"withWarranties" value:extendWarranty];
        }
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };
        LogURL(@"[CONTACT] getOrdersWithExtendWarranty Orders URL: %@",url);
        LogMicro(@"[CONTACT] getOrdersWithExtendWarranty Header: %@", headerDict);
        
        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *parserError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            WBRContactRequestOrdersArrayModel *ordersArray = [[WBRContactRequestOrdersArrayModel alloc] initWithDictionary:json error:&parserError];
            
            if (parserError) {
                LogErro(@"[CONTACT] getOrdersWithExtendWarranty ERROR Parser: %@", parserError);
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            }
            LogMicro(@"[CONTACT] getOrdersWithExtendWarranty Response Parsed: %@", ordersArray);
            if (successBlock) {
                successBlock(ordersArray);
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] getOrdersWithExtendWarranty ERROR Connection: %@ \n Failure date: %@", error.description, failureData);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }];
    }
}

+ (void)getDeliveriesWithOrderId:(NSString *)orderId success:(kContactManagerDeliveriesSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getDeliveriesWithOrderId");
        NSString *mockFile = kDeliveriesList;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSArray<WBRContactRequestDeliveryModel *> *deliveries = [json objectForKey:@"deliveries"];
        NSMutableArray<WBRContactRequestDeliveryModel *> *deliveriesMutable = [NSMutableArray new];
        
        for (NSDictionary *deliveryDict in deliveries) {
            NSError *parserError;
            WBRContactRequestDeliveryModel *delivery = [[WBRContactRequestDeliveryModel alloc] initWithDictionary:deliveryDict error:&parserError];
            if (parserError) {
                LogErro(@"[CONTACT] MOCK - getDeliveriesWithOrderId ERROR Parser: %@", parserError);

                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            } else {
                [deliveriesMutable addObject:delivery];
            }
        }
        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getDeliveriesWithOrderId Response Parsed: %@", deliveriesMutable);
            successBlock(deliveriesMutable.copy);
        } else {
            LogErro(@"[CONTACT] MOCK - getDeliveriesWithOrderId ERROR Parser: %@", parseError.description);
            if (failureBlock) {
                failureBlock(parseError);
            }
        }
    } else {
        NSString *url = [NSString stringWithFormat:@"%@%@", [WBRContactManagerUrls urlContactRequestDelivery], orderId];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };
        LogURL(@"[CONTACT] getDeliveriesWithOrderId URL: %@",url);
        LogMicro(@"[CONTACT] getDeliveriesWithOrderId Header: %@", headerDict);

        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *parserError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parserError];
            
            if (!parserError){
                NSArray<WBRContactRequestDeliveryModel *> *deliveries = [json objectForKey:@"deliveries"];
                NSMutableArray<WBRContactRequestDeliveryModel *> *deliveriesMutable = [NSMutableArray new];
                LogMicro(@"[CONTACT] getDeliveriesWithOrderId Response: %@ \n Data: %@", response, data);
                
                for (NSDictionary *deliveryDict in deliveries) {
                    NSError *parserError;
                    WBRContactRequestDeliveryModel *delivery = [[WBRContactRequestDeliveryModel alloc] initWithDictionary:deliveryDict error:&parserError];
                    if (parserError) {
                        LogErro(@"[CONTACT] getDeliveriesWithOrderId ERROR Parser: %@", parserError);
                        if (failureBlock) {
                            failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                        }
                    } else {
                        [deliveriesMutable addObject:delivery];
                    }
                }
                if (deliveriesMutable.count > 0) {
                    LogMicro(@"[CONTACT] getDeliveriesWithOrderId Response Parsed: %@", deliveriesMutable);
                    if (successBlock) {
                        successBlock(deliveriesMutable.copy);
                    }
                } else {
                    LogErro(@"[CONTACT] getDeliveriesWithOrderId ERROR Parser: No data was return");
                    
                    if (failureBlock) {
                        failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                    }
                }
            } else {
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] getDeliveriesWithOrderId ERROR Connection: %@ \n Failure date: %@", error.description, failureData);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }];
    }
}

+ (void)getExchangeWithOrderId:(NSString *)orderId andSellerId:(NSString *)sellerId success:(kContactManagerExchangeSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getExchangeWithOrderId");
        NSString *mockFile = kExchangeList;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        WBRContactRequestExchangeModel *contactExchange = [[WBRContactRequestExchangeModel alloc] initWithDictionary:json error:&parseError];

        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getExchangeWithOrderId Response: %@ ", contactExchange);
            successBlock(contactExchange);
        } else {
            LogErro(@"[CONTACT] MOCK - getExchangeWithOrderId FAIL: %@ ", parseError.description);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }
    } else {
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",[WBRContactManagerUrls urlContactRequestExchange], orderId, sellerId];
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };

        LogURL(@"[CONTACT] getExchangeWithOrderId URL: %@",url);
        LogMicro(@"[CONTACT] getExchangeWithOrderId Header: %@", headerDict);

        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *error;
            LogMicro(@"[CONTACT] getExchangeWithOrderId Response Data: %@", data);
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            WBRContactRequestExchangeModel *contactExchange = [[WBRContactRequestExchangeModel alloc] initWithDictionary:json error:&error];
            if (error) {
                LogErro(@"[CONTACT] getExchangeWithOrderId ERROR Parser: %@", error.description);
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            }
            if (successBlock) {
                LogMicro(@"[CONTACT] getExchangeWithOrderId Response Parsed: %@", contactExchange);
                successBlock(contactExchange);
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] getExchangeWithOrderId ERROR Parser: %@ \n Failure date: %@", error.description, failureData);

            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }];
    }
}

+ (void)getBanksWithSuccess:(kContactManagerBanksSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getBanksWithSuccess");
        NSString *mockFile = kBankList;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        NSMutableArray *banksMutableArray = [[NSMutableArray alloc] init];
        NSArray *responseArray = (NSArray *)json;
        
        __block NSError *parserError;
        
        [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *bankDictionary = (NSDictionary *)obj;
            Bank *bank = [[Bank alloc] initWithDictionary:bankDictionary error:&parserError];
            
            if (parserError) {
                LogErro(@"[CONTACT] MOCK - Parser error: %@", parserError);
                *stop = YES;
            } else {
                [banksMutableArray addObject:bank];
            }
        }];
        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getBanksWithSuccess Response: %@ ", banksMutableArray);
            successBlock(banksMutableArray);
        } else {
            LogErro(@"[CONTACT] MOCK - getBanksWithSuccess FAIL: %@ ", parseError.description);
            if (failureBlock) {
                failureBlock(parserError);
            }
        }

    } else {
        NSString *url = [WBRContactManagerUrls urlContactRequestBanks];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };
        LogURL(@"[CONTACT] getBanksWithSuccess URL: %@",url);
        LogMicro(@"[CONTACT] getBanksWithSuccess Header: %@", headerDict);

        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
            LogMicro(@"[CONTACT] getBanksWithSuccess Response: %@ \n Data: %@", response, data);
            NSError *parseError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError) {
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                }
            } else {
                NSMutableArray *banksMutableArray = [[NSMutableArray alloc] init];
                NSArray *responseArray = (NSArray *)json;
                
                __block NSError *parserError;
                
                [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *bankDictionary = (NSDictionary *)obj;
                    Bank *bank = [[Bank alloc] initWithDictionary:bankDictionary error:&parserError];
                    if (parserError) {
                        *stop = YES;
                    } else {
                        [banksMutableArray addObject:bank];
                    }
                }];
                
                if (parserError) {
                    LogErro(@"[CONTACT] getBanksWithSuccess - Parser error: %@", parserError);
                    if (failureBlock) {
                        failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
                    }
                } else {
                    LogMicro(@"[CONTACT] getBanksWithSuccess Response Parsed: %@", banksMutableArray);
                    if (successBlock) {
                        successBlock(banksMutableArray.copy);
                    }
                }
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] getOrderDetailsByOrderId - Connection error: %@ \n Failure Data: %@", error, failureData);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }];
    }
}

+ (void)getOrderDetailsByOrderId:(NSString *)orderId success:(kContactManagerOrderDetailsSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - getOrderDetailsByOrderId");
        NSString *mockFile = kOrderDetail;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        BOOL canceled = [json[@"canceled"] boolValue];
        BOOL warranty = [json[@"payment"][@"orderTotal"][@"warranty"] boolValue];

        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] MOCK - getOrderDetailsByOrderId Response Parsed: %@", json);
            successBlock(canceled, warranty);
        } else {
            LogErro(@"[CONTACT] MOCK - getOrderDetailsByOrderId FAIL: %@ ", parseError.description);
            if (failureBlock) {
                failureBlock(parseError);
            }
        }
    } else {
        NSString *url = [NSString stringWithFormat:@"%@/%@", [WBRContactManagerUrls urlContactRequestOrderDetail], orderId];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"system"      : dictInfo[@"system"],
                                     @"version"     : dictInfo[@"version"]
                                     };
        LogURL(@"[CONTACT] getOrderDetailsByOrderId URL: %@",url);
        LogMicro(@"[CONTACT] getOrderDetailsByOrderId Header: %@", headerDict);

        [[WBRConnection sharedInstance] GET:url headers:headerDict authenticationLevel:kAuthenticationLevelRequired successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *parseError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError) {
                LogErro(@"[CONTACT] getOrderDetailsByOrderId - Parser error: %@", parseError);
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_REQUEST_ERROR]);
            }
            BOOL canceled = [json[@"canceled"] boolValue];
            BOOL warranty = [json[@"payment"][@"orderTotal"][@"warranty"] boolValue];
            
            if (successBlock) {
                LogMicro(@"[CONTACT] getOrderDetailsByOrderId Response Parsed: %@", json);
                successBlock(canceled, warranty);
            }

        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] getOrderDetailsByOrderId - Connection error: %@ \n Failure Data: %@", error, failureData);

            if (failureBlock) {
                failureBlock([NSError errorWithCode:error.code message:CONTACT_REQUEST_REQUEST_ERROR]);
            }
        }];
    }
}

+ (void)openTicketWithDictionary:(NSDictionary *)contactDict success:(kContactManagerOpenTicketSuccessBlock)successBlock failure:(kContactManagerFailureBlock)failureBlock {
    
    if (USE_MOCK_CONTACT) {
        LogInfo(@"[CONTACT] USE MOCK CONTACT - openTicketWithDictionary");
        NSString *mockFile = kOpenTicket;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:mockFile ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *parseError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        
        NSNumber *ticketNumber = [json objectForKey:@"id"];

        if ((successBlock) && (!parseError)) {
            LogMicro(@"[CONTACT] openTicketWithDictionary Response Parsed: %@", json);
            successBlock(ticketNumber.stringValue);
        } else {
            LogErro(@"[CONTACT] MOCK - openTicketWithDictionary FAIL: %@ ", parseError.description);
            if (failureBlock) {
                failureBlock(parseError);
            }
        }
    } else {
        NSString *url = [WBRContactManagerUrls urlContactRequestOpenTicket];
        
        NSDictionary *headerDict = @{@"Content-Type": @"application/json;charset=UTF-8",
                                     @"Accept"      : @"application/json",
                                     @"platform"    : @"app"
                                     };
        
        LogURL(@"[CONTACT] openTicketWithDictionary URL:\n %@",url);
        LogMicro(@"[CONTACT] openTicketWithDictionary Header: \n %@", headerDict);
        LogMicro(@"[CONTACT] openTicketWithDictionary Body: \n %@", contactDict);
        
        [[WBRConnection sharedInstance] POST:url headers:headerDict body:contactDict authenticationLevel:kAuthenticationLevelOptional successBlock:^(NSURLResponse *response, NSData *data) {
            NSError *parseError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            LogMicro(@"[CONTACT] openTicketWithDictionary Response Data: %@", data);

            if (parseError || ![json objectForKey:@"ticketId"]) {
                LogErro(@"[CONTACT] openTicketWithDictionary - Parser error: %@", parseError);
                if (failureBlock) {
                    failureBlock([NSError errorWithMessage:CONTACT_REQUEST_SEND_REQUEST_ERROR]);
                }
            } else {
                LogMicro(@"[CONTACT] openTicketWithDictionary Response Parsed: %@", json);
                NSNumber *ticketNumber = [json objectForKey:@"ticketId"];
                if (successBlock) {
                    successBlock(ticketNumber.stringValue);
                }
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            LogErro(@"[CONTACT] openTicketWithDictionary - Connection error: %@ - /n FailureData :%@", error.description, failureData);
            if (failureBlock) {
                failureBlock([NSError errorWithMessage:CONTACT_REQUEST_SEND_REQUEST_ERROR]);
            }
        }];
    }
}

@end
