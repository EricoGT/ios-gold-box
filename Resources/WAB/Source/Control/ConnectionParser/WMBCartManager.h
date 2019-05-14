//
//  WMBCartManager.h
//  Walmart
//
//  Created by Bruno Delgado on 8/1/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBCartManager : NSObject

//Helpers
+ (NSString *)getCartFromDocs;
+ (void)parseCartAndToken:(NSString *) strCookie;

//Expired cart
+ (BOOL)isCartExpired:(NSString *) jsonError;
+ (BOOL)isCartEmpty:(NSString *) jsonError;

//Cart errors
+ (NSDictionary *)getErrorCodeMsg:(NSString *) jsonError;

//Convert to JSON
+ (NSString *)dictionaryToJson:(NSDictionary *) dict;

@end
