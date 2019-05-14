//
//  WALSession.m
//  Walmart
//
//  Created by Bruno Delgado on 6/28/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WALSession.h"
#import "MDSSqlite.h"

@implementation WALSession

+ (BOOL)isAuthenticated
{

    WMBTokenModel *tokenV2 = [[WMTokens new] getTokenOAuthWithoutRefreshToken];
    BOOL hasTokenV2 = (tokenV2 && tokenV2.accessToken.length > 0);
    if (hasTokenV2) return YES;

    BOOL hasTokenV1 = [MDSSqlite hasOldToken];
    if (hasTokenV1) return YES;

    return NO;
}

@end
