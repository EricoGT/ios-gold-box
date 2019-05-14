//
//  WBRUserManager.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 6/21/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

typedef void(^kUserManagerSuccessBlock)(void);
typedef void(^kUserManagerFailureBlock)(NSError *error);

@interface WBRUserManager : NSObject

+ (void)logoutUser;
+ (void)updateUserWithUserPersonalData:(User *)user fromCompleteScreen:(BOOL)complete successBlock:(kUserManagerSuccessBlock)successBlock failureBlock:(kUserManagerFailureBlock)failureBlock;
+ (void)changeUserPasswordWithNewPassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword successBlock:(kUserManagerSuccessBlock)successBlock failureBlock:(kUserManagerFailureBlock)failureBlock;

@end
