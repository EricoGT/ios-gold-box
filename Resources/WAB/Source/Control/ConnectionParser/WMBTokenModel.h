//
//  WMBTokenModel.h
//  Walmart
//
//  Created by Bruno Delgado on 7/22/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface WMBTokenModel : JSONModel

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSNumber *expiresIn;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithToken:(NSString *)token type:(NSString *)tokenType expiration:(NSNumber *)expires refreshToken:(NSString *)refresh;

- (BOOL)isExpired;

@end
