//
//  WBRFacebookLoginManager.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 05/11/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceUser.h"

@interface WBRFacebookLoginManager : NSObject

typedef void(^kFacebookLoginManagerSuccessBlock)(FaceUser *facebookUser, NSHTTPURLResponse *response);
typedef void(^kFacebookLoginManagerFailureBlock)(NSError *error, NSHTTPURLResponse *failResponse);
typedef void(^kFacebookLoginManagerSuccessStringBlock)(NSString *profilePictureUrl);

/**
 Do the login with Facebook Account

 @param successBlock success Block
 @param failureBlock failure Block
 */
+ (void)loginWithFacebookSuccess:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;

/**
 Get the Facebooks user login

 @param success success block
 @param failure failure block
 */
+ (void)getFacebookUserInformationsWithSuccess:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;

/**
 Link Facebook account with Walmart account

 @param guid guid from user
 @param facebookAccessToken Facebook access toker
 @param successBlock success block
 @param failureBlock failura block
 */
+ (void)linkFacebookWithGuid:(NSString *)guid andFacebookAccessToken:(NSString *)facebookAccessToken success:(void (^)())successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;

/**
 Unlink the facebook account from Walmart account

 @param guid guid string
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)unlinkFacebookWithGuid:(NSString *)guid success:(void (^)())successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;

/**
 Login on facebook with permissions

 @param permissions permissions array
 @param successBlock success block
 @param failureBlock failure block
 */
+ (void)loginWithPermissions:(NSArray *)permissions success:(kFacebookLoginManagerSuccessBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;


/**
 Get the profile picture from Facebook

 @param socialId social Id
 @param success success block
 @param failure failure block
 */
+ (void)getImageFacebook:(NSString *)socialId completionBlock:(kFacebookLoginManagerSuccessStringBlock)successBlock failure:(kFacebookLoginManagerFailureBlock)failureBlock;

/**
 Logout the user from facebook
 */
+ (void)logoutFacebook;

@end
