//
//  NSString+Cookies.m
//  Walmart
//
//  Created by Renan Cargnin on 07/10/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "NSString+Cookies.h"

//  Cookie example
//  "cart=app:15uh554vp3ub2v6x8z7b53bp;Path=/;Expires=Sat, 21-Jun-2014 15:06:19 GMT;Max-Age=1296000",

@implementation NSString (Cookies)

- (NSString *)cookieValueForKey:(NSString *)key {
    NSString *keyPrefix = [NSString stringWithFormat:@"%@=", key];
    NSArray *cookieValuesAndKeys = [self componentsSeparatedByString:@";"];
    
    for (NSString *cookieValueAndKey in cookieValuesAndKeys) {
        if ([cookieValueAndKey containsString:keyPrefix]) {
            NSString *cookieValue = cookieValueAndKey.copy;
            cookieValue = [cookieValue stringByReplacingOccurrencesOfString:keyPrefix withString:@""];
            cookieValue = [cookieValue stringByReplacingOccurrencesOfString:@";" withString:@""];
            return cookieValue;
        }
    }
    return nil;
}

@end
