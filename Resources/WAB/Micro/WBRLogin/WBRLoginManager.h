//
//  WBRLoginManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 29/10/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface WBRLoginManager : NSObject

typedef void(^kLoginManagerSuccessStringBlock)(NSString *dataString);
typedef void(^kLoginManagerFailureStringBlock)(NSError *error);

/**
 Make user login on Walmart app

 @param user username
 @param pass password
 @param isFacebook is from facebook or not
 @param isFacebookWithLink has facebook link or not
 @param snId SN identifier
 @param successBlock success completion
 @param failureBlock failure completion
 */
+ (void)loginWithUser:(NSString *)user pass:(NSString *)pass isFacebook:(BOOL)isFacebook isFacebookWithLink:(BOOL)isFacebookWithLink snId:(NSString *)snId  successBlock:(void (^)())successBlock failureBlock:(void (^)(NSError *))failureBlock;


/**
 Make user login on Walmart app

 @param document document
 @param pass password
 @param isFacebook is from facebook or not
 @param isFacebookWithLink has facebook link or not
 @param snId SN identifier
 @param successBlock success completion
 @param failureBlock failure completion
 */
+ (void)loginWithDocument:(NSString *)document pass:(NSString *)pass isFacebook:(BOOL)isFacebook isFacebookWithLink:(BOOL)isFacebookWithLink snId:(NSString *)snId successBlock:(void (^)())successBlock failureBlock:(void (^)(NSError *))failureBlock;

/**
 Reset Password with email string

 @param email email string
 @param success success block
 @param failure failure block
 */
+ (void)resetPasswordWithEmail:(NSString *)email success:(void (^)(NSString *maskedEmail))success failure:(void (^)(NSError *error))failure;


/**
 Reset Password with document (CPF/CNPJ)

 @param document CPF or CNPJ
 @param success success block
 @param failure failure block
 */
+ (void)resetPasswordWithDocument:(NSString *)document success:(void (^)(NSString *maskedEmail))success failure:(void (^)(NSError *error))failure;


/**
 Register user with user dict info

 @param userInfoDict user dict info
 @param isFacebook is with facebook
 @param snId sn id from user
 @param success success block
 @param failure failure block
 */
+ (void)registerUserWithUserInfoDict:(NSDictionary *)userInfoDict withFacebook:(BOOL)isFacebook andSnId:(NSString *)snId success:(void (^)())success failure:(void (^)(NSError *error))failure;

/**
 Get the user info data

 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)loadUserInfoDataWithSuccessBlock:(void (^)(User *))successBlock failureBlock:(void (^)(NSError *))failureBlock;

@end
