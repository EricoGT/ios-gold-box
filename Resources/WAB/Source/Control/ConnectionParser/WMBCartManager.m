//
//  WMBCartManager.m
//  Walmart
//
//  Created by Bruno Delgado on 8/1/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBCartManager.h"

@implementation WMBCartManager

//
//  This code was previously in WMTokens but it should be in a separate class
//  I ust moved the code over to this new class and turned the methods, class methods.
//

#pragma mark - Parse cookie Cart and Token
+ (void)parseCartAndToken:(NSString *) strCookie
{
    NSString *tkCheckout = @"";
    NSString *cartId = @"";

    //Example cookie
    //    "cookies":[
    //               "cart=app:15uh554vp3ub2v6x8z7b53bp;Path=/;Expires=Sat, 21-Jun-2014 15:06:19 GMT;Max-Age=1296000",
    //               "token=arh2jse5l1ci34ibph78rb4g3;Path=/;Expires=Sat, 21-Jun-2014 15:06:19 GMT;Max-Age=1296000"
    //               ]

    NSError *error = nil;
    NSData *jsonData = [strCookie dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    if ([jsonObjects valueForKey:@"cookies"]) {
        //If there is a cookie
        NSArray *arrElements = [jsonObjects valueForKey:@"cookies"];
        LogNewCheck(@"[WMTokens - parseCartAndToken] Cart Elements from Cookie: %@", arrElements);

        if ((int) [arrElements count] > 1) {

            if ([[arrElements objectAtIndex:0] rangeOfString:@"cart"].location != NSNotFound) {

                NSArray *cartArr = [[arrElements objectAtIndex:0] componentsSeparatedByString:@";"];
                NSString *cart = [cartArr objectAtIndex:0];
                cart = [cart stringByReplacingOccurrencesOfString:@"cart=" withString:@""];
                cartId = [cart stringByReplacingOccurrencesOfString:@";" withString:@""];
            }
            else {

                NSArray *cartArr = [[arrElements objectAtIndex:1] componentsSeparatedByString:@";"];
                NSString *cart = [cartArr objectAtIndex:0];
                cart = [cart stringByReplacingOccurrencesOfString:@"cart=" withString:@""];
                cartId = [cart stringByReplacingOccurrencesOfString:@";" withString:@""];
            }

            if (![cartId isEqualToString:@""]) {
                [[WMTokens new] addCartId:cartId];
            }
        }
        else {

            if ([[arrElements objectAtIndex:0] rangeOfString:@"cart"].location != NSNotFound) {

                NSArray *cartArr = [[arrElements objectAtIndex:0] componentsSeparatedByString:@";"];
                NSString *cart = [cartArr objectAtIndex:0];
                cart = [cart stringByReplacingOccurrencesOfString:@"cart=" withString:@""];
                cartId = [cart stringByReplacingOccurrencesOfString:@";" withString:@""];

                if (![cartId isEqualToString:@""]) {
                    [[WMTokens new] addCartId:cartId];
                }
            }
        }
    }

    NSDictionary *dictData = @{@"tkCheckout" :   tkCheckout,
                               @"cartId"     :   cartId
                               };

    LogNewCheck(@"[WMTokens - parseCartAndToken] Token and Cart: %@", dictData);
}

#pragma mark - Parse Errors when 400
+ (BOOL)isCartExpired:(NSString *) jsonError
{
    BOOL isExpired = NO;

    NSString *cart = @"";

    NSError *error = nil;
    NSData *jsonData = [jsonError dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    if ([jsonObjects valueForKey:@"errors"]) {

        NSArray *arrElements = [jsonObjects valueForKey:@"errors"];

        if ((int) [arrElements count] > 0) {

            if ([[arrElements objectAtIndex:0] valueForKey:@"message"]) {

                LogNewCheck(@"Message Content: %@", [[arrElements objectAtIndex:0] valueForKey:@"message"]);

                if ([[[arrElements objectAtIndex:0] valueForKey:@"message"] isKindOfClass:[NSDictionary class]])
                {
                    if ([[[arrElements objectAtIndex:0] valueForKey:@"message"] objectForKey:@"cookies"] != nil)
                    {
                        NSDictionary *dictMessage = [[arrElements objectAtIndex:0] valueForKey:@"message"];

                        NSArray *arrCookies = [dictMessage objectForKey:@"cookies"];

                        LogNewCheck(@"Cookie Error Content: %@", arrCookies);

                        if ((int) [arrCookies count] > 0) {

                            if ([[arrCookies objectAtIndex:0] rangeOfString:@"cart"].location != NSNotFound) {

                                NSArray *cartArr = [[arrCookies objectAtIndex:0] componentsSeparatedByString:@";"];
                                cart = [cartArr objectAtIndex:0];
                                cart = [cart stringByReplacingOccurrencesOfString:@"cart=" withString:@""];
                                cart = [cart stringByReplacingOccurrencesOfString:@";" withString:@""];
                                LogNewCheck(@"Cart Value error 0: %@", cart);

                            }
                            else {

                                if ((int) [arrCookies count] > 1) {
                                    NSArray *cartArr = [[arrCookies objectAtIndex:1] componentsSeparatedByString:@";"];
                                    NSString *cart = [cartArr objectAtIndex:0];
                                    cart = [cart stringByReplacingOccurrencesOfString:@"cart=" withString:@""];
                                    cart = [cart stringByReplacingOccurrencesOfString:@";" withString:@""];
                                    LogNewCheck(@"Cart Value error 1: %@", cart);
                                }
                            }

                        }
                    }
                    else {

                        //Get cartId
                        NSDictionary *message = [[arrElements objectAtIndex:0] valueForKey:@"message"];
                        LogInfo(@"Dict Message: %@", [message allKeys]);

                        NSDictionary *errorMap = [message objectForKey:@"errorMap"];
                        LogInfo(@"Dict ErrorMap: %@", [errorMap allKeys]);

                        NSDictionary *dictCart = [errorMap objectForKey:@"cart"];
                        LogInfo(@"Dict Cart: %@", [dictCart allKeys]);

                        cart = [dictCart objectForKey:@"id"];
                    }
                }
            }
        }
    }

    if ([cart isEqualToString:@""]) {

        isExpired = YES;
    }

    return isExpired;
}

+ (BOOL)isCartEmpty:(NSString *) jsonError
{
    BOOL isEmpty = NO;

    NSError *error = nil;
    NSData *jsonData = [jsonError dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    if ([jsonObjects valueForKey:@"errors"]) {

        NSArray *arrElements = [jsonObjects valueForKey:@"errors"];

        if ((int) [arrElements count] > 0) {

            if ([[arrElements objectAtIndex:0] valueForKey:@"message"]) {

                LogNewCheck(@"Message Content: %@", [[arrElements objectAtIndex:0] valueForKey:@"message"]);

                if ([[[arrElements objectAtIndex:0] valueForKey:@"message"] isKindOfClass:[NSString class]]) {

                    if ([[[arrElements objectAtIndex:0] valueForKey:@"message"] isEqualToString:@""]) {
                        LogInfo(@"Empty Cart");
                        isEmpty = YES;
                    }
                }
            }
        }
    }

    return isEmpty;
}

+ (NSDictionary *)getErrorCodeMsg:(NSString *) jsonError
{
    //For test
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"error9" ofType:@"json"];
    //    jsonError = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    LogErro(@"Json Error 400 general: %@", jsonError);

    NSDictionary *msg = [NSDictionary new];

    NSError *error = nil;
    NSData *jsonData = [jsonError dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    LogNewCheck(@"Name: %@", [jsonObjects valueForKey:@"name"]);
    if ([jsonObjects valueForKey:@"errors"])
    {
        NSArray *arrElements = [jsonObjects valueForKey:@"errors"];
        LogNewCheck(@"Errors Array: %@", arrElements);

        if ((int) [arrElements count] > 0)
        {
            if ([[arrElements objectAtIndex:0] valueForKey:@"message"])
            {
                NSDictionary *dictMessage = [[arrElements objectAtIndex:0] valueForKey:@"message"];
                NSString *errorCode = @"";
                if ([dictMessage isKindOfClass:[NSDictionary class]])
                {
                    errorCode = [dictMessage objectForKey:@"errorCode"];
                    if (!errorCode) {
                        errorCode = @"";
                    }
                }
                LogNewCheck(@"Error Code: %@", errorCode);

                BOOL foundErrorId = NO;
                NSString *errorMessage = @"";
                if ([dictMessage isKindOfClass:[NSDictionary class]])
                {
                    errorMessage = [dictMessage objectForKey:@"errorMessage"];
                    if (!errorMessage) {
                        errorMessage = @"";
                    }
                }
                LogNewCheck(@"Error Message: %@", errorMessage);

                //Verify if a preauthorization error
                BOOL preAuthError = NO;
                if (![errorMessage isKindOfClass:[NSNull class]] || !errorMessage) {

                    if (errorMessage.length > 0)
                    {
                        if ([errorMessage isEqualToString:@"PREAUTH"]) {
                            preAuthError = YES;
                            msg = @{@"errorCode" : errorCode,@"errorMessage" : errorMessage};
                        }
                    }
                } else {

                    errorMessage = @"";
                }

                if (!preAuthError) {
                    if (errorMessage) {
                        if (errorMessage.length <= 0) errorMessage = @"";
                    }

                    NSArray *arrErroMsgId = [errorMessage componentsSeparatedByString:@"\n"];
                    if ((int) [arrErroMsgId count] > 1) {

                        errorMessage = [arrErroMsgId objectAtIndex:1];
                        LogNewCheck(@"Error String Place Order: %@", errorMessage);

                        jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                        jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

                        //If I can retrieve the code
                        if ([jsonObjects valueForKey:@"errorId"])
                        {
                            foundErrorId = YES;
                            if ([dictMessage isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary *dictMap = [dictMessage objectForKey:@"errorMap"];
                                if ([dictMap objectForKey:@"placeOrderError"]) {
                                    NSDictionary *dictPOErrors = [dictMap objectForKey:@"placeOrderError"];
                                    msg = @{@"errorCode"    :   [dictPOErrors objectForKey:@"errorCode"],
                                            @"errorLevel"   :   [dictPOErrors objectForKey:@"errorLevel"],
                                            @"errorId"  :   [jsonObjects valueForKey:@"errorId"]};
                                }
                                else {
                                    //placeOrderError not found
                                    msg = @{@"errorId"  :   [jsonObjects valueForKey:@"errorId"]};
                                }
                            }
                        }
                    }

                    //If errorId is not fount
                    if (!foundErrorId) {

                        NSDictionary *dictMap;
                        if ([dictMessage isKindOfClass:[NSDictionary class]]) {
                            dictMap = [dictMessage objectForKey:@"errorMap"] ?: nil;
                            LogNewCheck(@"Dict Map: %@", dictMap);
                        }

                        //Verif if it is a sellerErrors
                        if ([dictMap objectForKey:@"sellerErrors"]) {

                            //Yes, it's a seller error
                            NSDictionary *dictSellerErrors = [dictMap objectForKey:@"sellerErrors"];
                            LogNewCheck(@"Dict Seller Errors: %@", dictSellerErrors);

                            //Determine the key of seller (or sellers)
                            if ([dictSellerErrors respondsToSelector:@selector(allKeys)])
                            {
                                NSArray *arrKeysSellers = [dictSellerErrors allKeys];
                                LogNewCheck(@"Array Keys of sellers errors: %@", arrKeysSellers);

                                //Search by Cart
                                NSDictionary *dictCart = [NSDictionary new];

                                if ([dictMap objectForKey:@"cart"]) {
                                    dictCart = [dictMap objectForKey:@"cart"];
                                }

                                if (arrKeysSellers.count > 0) {
                                    //Let's get only first key
                                    NSDictionary *dictErrorsFromSellerByKey = [dictSellerErrors objectForKey:[arrKeysSellers objectAtIndex:0]];

                                    msg = @{@"sellerId"     :   [arrKeysSellers objectAtIndex:0],
                                            @"errorCode"    :   [dictErrorsFromSellerByKey objectForKey:@"errorCode"],
                                            @"errorLevel"   :   [dictErrorsFromSellerByKey objectForKey:@"errorLevel"],
                                            @"cart"         :   dictCart
                                            };
                                }
                            }
                        }

                        //Verif if it is a placeOrderError
                        if ([dictMap objectForKey:@"placeOrderError"]) {

                            //Yes, it's a seller error
                            NSDictionary *dictPOErrors = [dictMap objectForKey:@"placeOrderError"];

                            msg = @{@"errorCode"    :   [dictPOErrors objectForKey:@"errorCode"],
                                    @"errorLevel"   :   [dictPOErrors objectForKey:@"errorLevel"]
                                    };
                        }
                        
                        //Verify if it is cart overflow
                        if ([dictMessage isKindOfClass:[NSDictionary class]]) {
                            NSString *error_id = [dictMessage objectForKey:@"errorId"] ?: @"";
                            if ([error_id isEqualToString:@"CART_OVERFLOW"]) {
                                msg = @{@"errorCode" : [dictMessage objectForKey:@"errorId"],@"errorMessage" : [dictMessage objectForKey:@"message"] ?: @""};
                            }
                        }
                    }

                }

            }

        }
    }

    return msg;
}

//BDA (01/07/2016) - This is not using, but it's marked as backup. Should we keep it?
- (NSString *)getErrorCodeMsgBackup:(NSString *) jsonError
{
    LogErro(@"Json Error 400 general: %@", jsonError);

    NSString *msg = @"";

    NSError *error = nil;
    NSData *jsonData = [jsonError dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    LogNewCheck(@"Name: %@", [jsonObjects valueForKey:@"name"]);

    if ([jsonObjects valueForKey:@"errors"]) {

        NSArray *arrElements = [jsonObjects valueForKey:@"errors"];
        LogNewCheck(@"Errors Array: %@", arrElements);

        if ((int) [arrElements count] > 0) {

            if ([[arrElements objectAtIndex:0] valueForKey:@"message"]) {

                LogNewCheck(@"Message: %@", [[arrElements objectAtIndex:0] valueForKey:@"message"]);

                NSDictionary *errorMap = [[[arrElements objectAtIndex:0] valueForKey:@"message"] objectForKey:@"errorMap"];
                LogNewCheck(@"Error Map: %@", errorMap);

                if ([errorMap objectForKey:@"sellerErrors"]) {
                    //Then, we have a seller error
                    LogNewCheck(@"This is a seller error!");

                    NSDictionary *sellerErrors = [errorMap objectForKey:@"sellerErrors"];
                    LogNewCheck(@"Seller Errors: %@", sellerErrors);

                    NSArray *arrKeys = [sellerErrors allKeys];
                    LogNewCheck(@"ArrKeys Seller Errors: %@", arrKeys);

                    //Search by crazy index (seller id)
                    if ((int) [arrKeys count] > 0) {

                        NSDictionary *dictErrors = [sellerErrors objectForKey:[arrKeys objectAtIndex:0]];

                        if ([dictErrors objectForKey:@"errorCode"]) {
                            LogNewCheck(@"errorCode Seller: %@", [dictErrors objectForKey:@"errorCode"]);
                            msg = [dictErrors objectForKey:@"errorCode"];
                        }
                        if ([dictErrors objectForKey:@"errorLevel"]) {
                            LogNewCheck(@"errorLevel Seller: %@", [dictErrors objectForKey:@"errorLevel"]);
                        }
                    }
                }
                else if ([errorMap objectForKey:@"placeOrderError"]) {

                    LogNewCheck(@"This is a placeorder error!");

                    NSDictionary *placeOrderErrors = [errorMap objectForKey:@"placeOrderError"];
                    LogNewCheck(@"PlaceOrder Errors: %@", placeOrderErrors);

                    if ([placeOrderErrors objectForKey:@"errorCode"]) {
                        LogNewCheck(@"errorCode PlaceOrder: %@", [placeOrderErrors objectForKey:@"errorCode"]);
                        msg = [placeOrderErrors objectForKey:@"errorCode"];
                    }
                    if ([placeOrderErrors objectForKey:@"errorLevel"]) {
                        LogNewCheck(@"errorLevel PlaceOrder: %@", [placeOrderErrors objectForKey:@"errorLevel"]);
                    }

                    //Trying isolate code error in ErrorMessage
                    NSString *errorMessageId = [[[arrElements objectAtIndex:0] valueForKey:@"message"] objectForKey:@"errorMessage"];

                    //Search by array with json error msg
                    NSArray *arrErroMsgId = [errorMessageId componentsSeparatedByString:@"\n"];
                    errorMessageId = [arrErroMsgId objectAtIndex:1];
                    LogNewCheck(@"Error String Place Order: %@", errorMessageId);

                    jsonData = [errorMessageId dataUsingEncoding:NSUTF8StringEncoding];
                    jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

                    if ([jsonObjects valueForKey:@"errorId"]) {
                        msg = [jsonObjects valueForKey:@"errorId"];
                    }
                }


            }


        }
    }

    return msg;
}

#pragma mark - Convert to Json
+ (NSString *)dictionaryToJson:(NSDictionary *)dict
{
    NSString *jsonConverted = @"";

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        LogInfo(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        jsonConverted = jsonString;
    }

    return jsonConverted;
}


#pragma mark - Get Cart from Docs folder

+ (NSString *) getCartFromDocs {

    NSString *fileName = @"cartOnline";
    NSString *dataPath = @"";
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *categoriesDir = [docsDir stringByAppendingPathComponent:@"Cart"];
    NSString *fileToRead = [NSString stringWithFormat:@"%@.json", fileName];
    dataPath = [[NSString alloc] initWithString:[categoriesDir stringByAppendingPathComponent:fileToRead]];

    NSString *contentFile = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];

    LogNewCheck(@"Cart from docs: %@", contentFile);

    if (!contentFile) {
        
        contentFile = @"";
    }
    
    return contentFile;
}

@end
