//
//  WMBTokenMigration.m
//  Walmart
//
//  Created by Bruno Delgado on 8/2/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMBTokenMigration.h"
#import "MDSSqlite.h"
#import "FXKeychain.h"
#import "NSString+Validation.h"
#import "WBRLoginManager.h"

@implementation WMBTokenMigration

+ (void)migrateToken {
    WMBTokenMigration *tokenMigrationInstance = [WMBTokenMigration new];
    BOOL needsMigration = [tokenMigrationInstance needsTokenMigration];
    if (needsMigration) {
        FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
        NSData *passData = [keychainItem objectForKey:kPassKeychainKey];
        NSString *login = [keychainItem objectForKey:kUserKeychainKey];
        NSString *secretKey = [[NSString alloc] initWithData:passData encoding:NSUTF8StringEncoding];

        if ([login isEmail]) {
            [WBRLoginManager loginWithUser:login pass:secretKey isFacebook:nil isFacebookWithLink:nil snId:nil successBlock:^{
                [tokenMigrationInstance didMigrateWithSuccess];
            } failureBlock:^(NSError *error) {
                [tokenMigrationInstance didMigrateWithSuccess];
            }];
        }
    }
}

- (BOOL)needsTokenMigration
{
    BOOL authenticated = [WALSession isAuthenticated];
    if (!authenticated)
    {
        return NO;
    }

    BOOL hasOldToken = [MDSSqlite hasOldToken];
    if (!hasOldToken)
    {
        return NO;
    }

    return YES;
}

- (void)didMigrateWithSuccess
{
    [MDSSqlite clearOldToken];
}


@end
