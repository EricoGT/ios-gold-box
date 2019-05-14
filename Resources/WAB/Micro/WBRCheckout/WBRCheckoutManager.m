//
//  WBRCheckoutManager.m
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCheckoutManager.h"

#import "WBRConnection.h"
#import "WBRUTM.h"
#import "NSError+CustomError.h"
#import "FlurryWM.h"
#import "OFLogService.h"


@implementation WBRCheckoutManager

+ (void)addProductToCartWithSKU:(NSNumber *)sku sellerId:(NSString *)sellerId warrantiesId:(NSArray *)warrantiesId quantity:(NSUInteger)quantity success:(kCheckoutManagerSuccessBlock)successBlock failure:(kCheckoutManagerFailureBlock)failureBlock {
    
    LogInfo(@"[WBRCheckoutManager] addProductToCartWithSKU:sellerId:warrantiesId:quantity:success:failure:");
    
    NSDictionary *dataDictionary = @{
                                     @"skuId": sku ?: @"",
                                     @"sellerId": sellerId ?: @"",
                                     @"idWarranty": warrantiesId ?: @[],
                                     @"quantity": @(quantity) ?: @""
                                     };
    [WMOmniture trackAddingProductInCart:dataDictionary];
    
    NSString *warranties = [self warrantyParameterWithArray:warrantiesId];
    NSString *addToCartURL = [NSString stringWithFormat:@"%@%@/sku/%@/services/%@/quantity/%ld", URL_CART_ADDPRODUCT_NEW, sellerId, sku, warranties, (long)quantity];
    NSString *addToCartFullURL = [[WBRUTM addUTMQueryParameterTo:[NSURL URLWithString:addToCartURL]] absoluteString];
    
    NSDictionary *headerDictionary = @{
                                       @"Content-Type": @"application/json",
                                       @"Accept": @"application/json",
                                       @"token": [[WMTokens new] getTokenCheckout],
                                       @"cart": [[WMTokens new] getCartId]
                                       };
    
    [[WBRConnection sharedInstance] GET:addToCartFullURL headers:headerDictionary authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
       
        [self updateTokensWithResponse:response];
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
        [WMBCartManager parseCartAndToken:dataString];
        
        if (successBlock) {
            successBlock(nil);
        }
    } failureBlock:^(NSError *error, NSData *failureData) {
        
        [self logAddProductToCartErrorWithError:error data:failureData forURL:addToCartFullURL];
        
        error = [self addProductToCartErrorWithError:error data:failureData];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (NSString *)warrantyParameterWithArray:(NSArray *)warranties {
    
    NSMutableString *strIdsWarranties = @"null".mutableCopy;
    for (NSString *warrantyId in warranties) {
        if (warrantyId == warranties.firstObject) {
            strIdsWarranties = warrantyId.mutableCopy;
        }
        else {
            [strIdsWarranties appendFormat:@",%@", warrantyId];
        }
    }
    
    return strIdsWarranties;
}

+ (void)updateTokensWithResponse:(NSURLResponse *)response {
    
    NSDictionary *header = [(NSHTTPURLResponse *)response allHeaderFields];
    if ([header objectForKey:@"cart"]) {
        [[WMTokens new] addCartId:[header objectForKey:@"cart"]];
    }
    
    if ([header objectForKey:@"token"]) {
        [[WMTokens new] addTokenCheckout:[header objectForKey:@"token"]];
    }
}

+ (void)getCartWithSuccess:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock {
   
    NSURL *url = [NSURL URLWithString:URL_CART_LOAD];
    NSString *stringURL = [WBRUTM addUTMQueryParameterTo:url].absoluteString;
    
    BOOL internetTest = [InternetTest internetOk];

    NSDictionary *dictInfo = [OFSetup infoAppToServer];

    NSDictionary *dictAuthStatus = [[NSDictionary alloc] initWithDictionary:[self authData]];
    NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"];
    NSString *cartId = [dictAuthStatus objectForKey:@"cart"];

    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    if (internetTest) {
        if (tkCk.length > 0) {
            [headerDict setValue:tkCk forKey:@"token"];
        }
        if (cartId.length > 0) {
            [headerDict setValue:cartId forKey:@"cart"];
        }
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        [[WBRConnection sharedInstance] GET:stringURL headers:headerDict authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];

            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogNewCheck(@"\n[WBRCheckouManager - getCartWithSuccesst] Response Cart: \n\n%@\n\n", file);
            
            NSString *fileName = @"cartOnline";
            NSString *dataPath = @"";
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            
            NSString *categoriesDir = [docsDir stringByAppendingPathComponent:@"Cart"];
            
            [[NSFileManager defaultManager] createDirectoryAtPath:categoriesDir withIntermediateDirectories:NO attributes:nil error:nil];
            
            NSString *fileToSave = [NSString stringWithFormat:@"%@.json", fileName];
            dataPath = [[NSString alloc] initWithString:[categoriesDir stringByAppendingPathComponent:fileToSave]];
            LogNewCheck(@"[WBRCheckouManager - getCartWithSuccess] Document saved LoadCart: %@", dataPath);
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:dataPath];
            [fileHandle writeData:data];
            [fileHandle closeFile];
            
            BOOL writeFileSuccess = [data writeToFile:dataPath atomically:YES];
            
            if (writeFileSuccess) {
                LogNewCheck(@"[WMConnectionNewCheckout - getCartWithGet] Arquivo Cart salvo (LoadCart) :)");
            } else {
                LogErro(@"[WMConnectionNewCheckout - getCartWithGet] Erro Salvando arquivo!");
            }
            
            if (successBlock) {
                successBlock(file);
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            LogNewCheck(@"\n[WBRCheckouManager - getCartWithSuccesst] Failed Response Cart: \n\n%@\n\n", file);
            
            if (failureBlock) {
                failureBlock(error, file);
            }
            
            [FlurryWM logEvent_communication_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                                        @"message"      :   error.description,
                                                        @"method"       :   @"getCartWithGet:"}];
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code] andResponseData:error.description andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:@"getCartWithGet:"];
        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"getCartWithGet"}];
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"getCartWithGet:"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self errorCartWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (void)updateProductWithCartDict:(NSDictionary *)cartDict andProductBodyJson:(NSString *)productJsonBody success:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock {

    NSURL *url = [NSURL URLWithString:URL_CART_UPDPRODUCT];
    NSString *stringURL = [WBRUTM addUTMQueryParameterTo:url].absoluteString;
    LogURL(@"[WBRCheckoutManager - updateProductWithCartDict] URL: %@", stringURL);

    BOOL internetTest = [InternetTest internetOk];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    
    NSDictionary *dictAuthStatus = [[NSDictionary alloc] initWithDictionary:[self authData]];
    NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"];
    NSString *cartId = [dictAuthStatus objectForKey:@"cart"];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    if (internetTest) {
        NSString *jsonUpdate = [productJsonBody stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        LogInfo(@"Json Update: %@", jsonUpdate);

        if (tkCk.length > 0) {
            [headerDict setValue:tkCk forKey:@"token"];
        }
        if (cartId.length > 0) {
            [headerDict setValue:cartId forKey:@"cart"];
        }
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        NSData *data = [jsonUpdate dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [[WBRConnection sharedInstance] PUT:stringURL headers:headerDict body:jsonBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];

            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            if (successBlock) {
                successBlock(file);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            LogNewCheck(@"\n[WBRCheckoutManager - updateProductWithCartDict] Failed Response Cart: \n\n%@\n\n", file);

            if (failureBlock) {
                failureBlock(error, file);
            }
        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"updateProduct:andBody:"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"updateProduct:andBody:"];

        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self errorCartWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (void)removeProductWithCartDict:(NSDictionary *)cartDict andProductBodyJson:(NSString *)productJsonBody success:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock {
    NSURL *url = [NSURL URLWithString:URL_CART_DELPRODUCT];
    NSString *stringURL = [WBRUTM addUTMQueryParameterTo:url].absoluteString;
    LogURL(@"[WBRCheckoutManager - removeProductWithCartDict] URL: %@", url);

    BOOL internetTest = [InternetTest internetOk];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    
    NSDictionary *dictAuthStatus = [[NSDictionary alloc] initWithDictionary:[self authData]];
    NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"];
    NSString *cartId = [dictAuthStatus objectForKey:@"cart"];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    if (internetTest) {
        NSString *jsonUpdate = [productJsonBody stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        LogInfo(@"Json Update: %@", jsonUpdate);
        
        if (tkCk.length > 0) {
            [headerDict setValue:tkCk forKey:@"token"];
        }
        if (cartId.length > 0) {
            [headerDict setValue:cartId forKey:@"cart"];
        }
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        NSData *data = [jsonUpdate dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [[WBRConnection sharedInstance] PUT:stringURL headers:headerDict body:jsonBody authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (successBlock) {
                successBlock(file);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            LogNewCheck(@"\n[WBRCheckoutManager - updateProductWithCartDict] Failed Response Cart: \n\n%@\n\n", file);
            
            if (failureBlock) {
                failureBlock(error, file);
            }
        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"removeProduct:andBody:"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"removeProduct:andBody:"];

        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self errorCartWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}

+ (void)getAddressList:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock {
    
    NSString *stringURL = [NSURL URLWithString:URL_LIST_ADDRESS].absoluteString;
    LogURL(@"URL List Address: %@", stringURL);

    BOOL internetTest = [InternetTest internetOk];
    
    NSDictionary *dictInfo = [OFSetup infoAppToServer];
    
    NSDictionary *dictAuthStatus = [[NSDictionary alloc] initWithDictionary:[self authData]];
    NSString *tkCk = [dictAuthStatus objectForKey:@"tkCk"];
    NSString *cartId = [dictAuthStatus objectForKey:@"cart"];
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
    
    if ([tkCk isEqualToString:@""] || [cartId isEqualToString:@""]) {
        
        if (failureBlock) {
            NSError *error = [NSError errorWithCode:1111 message:@""];
            error = [self errorCartWithError:error];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        }
    }

    if (internetTest) {
        
        if (tkCk.length > 0) {
            [headerDict setValue:tkCk forKey:@"token"];
        }
        if (cartId.length > 0) {
            [headerDict setValue:cartId forKey:@"cart"];
        }
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        
        
        [[WBRConnection sharedInstance] GET:stringURL headers:headerDict authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LogNewCheck(@"File List Address: %@", file);
            if (successBlock) {
                successBlock(file);
            }
            
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            LogNewCheck(@"\n[WBRCheckoutManager - getAddressList] Failed Response Cart: \n\n%@\n\n", file);
            
            if (failureBlock) {
                failureBlock(error, file);
            }
        }];
    } else {
        
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"listAddress"}];
        
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", stringURL] andRequestData:@"" andResponseCode:ERROR_CONNECTION_INTERNET andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:@"listAddress"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self errorCartWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }

    }
}

+ (void)getDeliveryOptions:(NSString *)deliveryId successBlock:(kCheckoutManagerSuccessStringBlock)successBlock failure:(kCheckoutManagerFailureStringBlock)failureBlock {
    NSString *urlSelect = [URL_SHIPMENT_OPTIONS stringByAppendingString:deliveryId];
    NSURL *url = [NSURL URLWithString:urlSelect];
    NSString *stringURL = [WBRUTM addUTMQueryParameterTo:url].absoluteString;
    LogURL(@"URL ship options: %@", stringURL);

    NSDictionary *dictAuthStatus = [self authData];
    LogNewCheck(@"[WMConnectionNewCheckout - selectOptions] Status Auth: %@", dictAuthStatus);

    NSString *tokenCheckout = [dictAuthStatus objectForKey:@"tkCk"] ?: @"";

    if ([tokenCheckout isEqualToString:@""]) {
        
        LogErro(@"Invalid new token from checkout (select options)!");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [FlurryWM logEvent_error:@{@"response_code":    @"TOKEN MISSED",
                                       @"message"      :    @"TOKEN MISSED",
                                       @"method"       :    @"selectOptions:"}];
            
            [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:@"TOKEN MISSED" andUserMessage:@"" andScreen:@"WMConnectionNewCheckout" andFragment:@"selectOptions:"];
            
            NSError *error = [NSError errorWithCode:1111 message:@""];
            error = [self errorCartWithError:error];
            if (failureBlock) {
                failureBlock(error, nil);
            }
        });
    }

    BOOL internetTest = [InternetTest internetOk];
    
    if (internetTest) {
        //Get token from OAuth
        NSString *usrTok = tokenCheckout;
        
        LogInfo(@"Token Ship Options : %@", usrTok);
        
        NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] init];
        
        [headerDict setValue:@"application/json" forKey:@"Content-Type"];
        
        NSDictionary *dictInfo = [OFSetup infoAppToServer];
        [headerDict setValue:[dictInfo objectForKey:@"system"] forKey:@"system"];
        [headerDict setValue:[dictInfo objectForKey:@"version"] forKey:@"version"];
        [headerDict setValue:usrTok forKey:@"token"];
    
        [[WBRConnection sharedInstance] GET:stringURL headers:headerDict authenticationLevel:kAuthenticationLevelNotRequired successBlock:^(NSURLResponse *response, NSData *data) {
            [self verifyIfUpdateCartAndToken:[(NSHTTPURLResponse *)response allHeaderFields]];
            NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            if (successBlock) {
                successBlock(file);
            }
        } failureBlock:^(NSError *error, NSData *failureData) {
            NSString *file = [[NSString alloc] initWithData:failureData encoding:NSUTF8StringEncoding];
            error = [self errorCartWithError:error];
            if (failureBlock) {
                failureBlock(error, file);
            }
        }];
    } else {
        [FlurryWM logEvent_communication_error:@{@"response_code"   : ERROR_CONNECTION_INTERNET,
                                                 @"message"      :   ERROR_CONNECTION_INTERNET,
                                                 @"method"       :   @"selectOptions:"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR" andRequestUrl:[NSString stringWithFormat:@"%@", [url absoluteString]] andRequestData:@"" andResponseCode:@"" andResponseData:ERROR_CONNECTION_INTERNET andUserMessage:ERROR_CONNECTION_INTERNET andScreen:@"WMConnectionNewCheckout" andFragment:@"selectOptions:"];
        
        NSError *error = [NSError errorWithCode:1009 message:@""];
        error = [self errorCartWithError:error];
        if (failureBlock){
            failureBlock(error, nil);
        }
    }
}


+ (void) verifyIfUpdateCartAndToken:(NSDictionary *) header {
    LogNewCheck(@"[WBRCheckouManager - verifyByNewToken] header: %@", header);
    //Update Cart Id and/or token
    if ([header objectForKey:@"cart"]) {
        [[WMTokens new] addCartId:[header objectForKey:@"cart"]];
    }
    if ([header objectForKey:@"token"]) {
        [[WMTokens new] addTokenCheckout:[header objectForKey:@"token"]];
    }
}

#pragma mark - Helper Auth
+ (NSDictionary *) authData {
    //Get all values
    NSMutableDictionary *authStatus = [[NSMutableDictionary alloc] init];
    [authStatus setValue:[[WMTokens new] getTokenCheckout] forKey:@"tkCk"];
    [authStatus setValue:[[WMTokens new] getCartId] forKey:@"cart"];
    
    return [NSDictionary dictionaryWithDictionary:authStatus];
}

#pragma mark - Log

+ (void)logAddProductToCartErrorWithError:(NSError *)error data:(NSData *)data forURL:(NSString *)url {
    
    NSString *file = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
    if (error.code == 400) {
        
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR"
                                     andRequestUrl:[NSString stringWithFormat:@"%@", url]
                                    andRequestData:@""
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code]
                                   andResponseData:file
                                    andUserMessage:@""
                                         andScreen:@"WMConnectionNewCheckout"
                                       andFragment:@"addNewProductWithGet:"];
        
        [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                   @"message"      :   file,
                                   @"method"       :   @"addNewProductWithGet:",
                                   @"screen"       :   @"productDetail"}];
    }
    else if (error.code == 408) {
        [FlurryWM logEvent_error:@{@"response_code"   : [NSString stringWithFormat:@"%li", (long)error.code],
                                   @"message"      :   error.description,
                                   @"method"       :   @"addNewProductWithGet:",
                                   @"screen"       :   @"productDetail"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR"
                                     andRequestUrl:url
                                    andRequestData:@""
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code]
                                   andResponseData:error.description
                                    andUserMessage:@""
                                         andScreen:@"WMConnectionNewCheckout"
                                       andFragment:@"addNewProductWithGet:"];
    }
    else if (error.code == 1009) {
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR"
                                     andRequestUrl:url
                                    andRequestData:@""
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code]
                                   andResponseData:ERROR_CONNECTION_INTERNET
                                    andUserMessage:ERROR_CONNECTION_INTERNET
                                         andScreen:@"WMConnectionNewCheckout"
                                       andFragment:@"addNewProductWithGet:"];
    }
    else {
        [FlurryWM logEvent_error:@{@"response_code": [NSString stringWithFormat:@"%li", (long)error.code],
                                   @"message"      : file,
                                   @"method"       : @"addProductWithGet"}];
        [[OFLogService new] sendLogsWithErrorEvent:@"EVENT_COMMUNICATION_ERR"
                                     andRequestUrl:url
                                    andRequestData:@""
                                   andResponseCode:[NSString stringWithFormat:@"%li", (long)error.code]
                                   andResponseData:file
                                    andUserMessage:@""
                                         andScreen:@"WMConnectionNewCheckout"
                                       andFragment:@"addNewProductWithGet:"];
    }
}

#pragma mark - Error Handler

+ (NSError *)errorCartWithError:(NSError *)error {
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

+ (NSError *)addProductToCartErrorWithError:(NSError *)error data:(NSData *)data {

    switch (error.code) {
        case 0:
            error = [NSError errorWithMessage:ERROR_CONNECTION_DATA];
            break;
        case 408:
            error = [NSError errorWithMessage:ERROR_CONNECTION_TIMEOUT];
            break;
        case 400:
            error = [self addProductToCart400Error:error data:data];
            break;
        case 1009:
            error = [NSError errorWithMessage:ERROR_CONNECTION_INTERNET];
            break;
        default:
            error = [self addProductToCartDefaultError:error data:data];
            break;
    }
    return error;
}

+ (NSError *)addProductToCart400Error:(NSError *)error data:(NSData *)data {
    
    NSDictionary *errorJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *errorMessage = ERROR_CONNECTION_UNKNOWN;
    if (errorJson) {
        
        NSArray *errors = [errorJson objectForKey:@"errors"];
        if (errors.count > 0) {
            
            NSDictionary *errorDictionary = [errors[0] objectForKey:@"message"];
            if (errorDictionary) {
                
                NSString *errorID = errorDictionary[@"errorId"];
                if ([errorID isEqualToString:@"PRODUCT_INACTIVE_ON_SELLER"] || [errorID isEqualToString:@"PRODUCT_NOT_FOUND"]) {
                    errorMessage = PRODUCT_UNAVAILABLE;
                }
                else if ([errorID isEqualToString:@"CART_ITEM_OVERFLOW"]) {
                    errorMessage = PRODUCT_CART_ITEM_OVERFLOW;
                }
                else if ([errorID isEqualToString:@"CART_OVERFLOW"]) {
                    errorMessage = PRODUCT_CART_OVERFLOW;
                }
            }
        }
    }
    
    NSError *handledError = [NSError errorWithMessage:errorMessage];
    
    return handledError;
}

+ (NSError *)addProductToCartDefaultError:(NSError *)error data:(NSData *)data {
    
    NSDictionary *errorJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *errorMessage = ERROR_CONNECTION_UNKNOWN;
    if (errorJson) {
        
        NSArray *errors = [errorJson objectForKey:@"errors"];
        if (errors.count > 0) {
            
            NSDictionary *errorDictionary = [errors[0] objectForKey:@"message"];
            if (errorDictionary) {
                
                NSString *errorID = errorDictionary[@"errorId"];
                if ([errorID isEqualToString:@"PRODUCT_INACTIVE_ON_SELLER"] ||
                    [errorID isEqualToString:@"PRODUCT_NOT_FOUND"]) {
                    errorMessage = PRODUCT_UNAVAILABLE;
                }
                else if ([errorID isEqualToString:@"CART_ITEM_OVERFLOW"]) {
                    errorMessage = PRODUCT_CART_ITEM_OVERFLOW;
                }
                else if ([errorID isEqualToString:@"CART_OVERFLOW"]) {
                    errorMessage = PRODUCT_CART_OVERFLOW;
                }
            }
        }
    }
    
    return [NSError errorWithMessage:errorMessage];
}

@end
