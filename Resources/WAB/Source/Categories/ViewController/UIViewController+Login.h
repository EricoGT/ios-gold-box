//
//  UIViewController+Login.h
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Login)

/**
 *  Presents the login controller with a block of code to be executed after a successfull login.
 *
 *  @param loginSuccessBlock The block code that will be executed after a successfull login.
 */
- (void)presentLoginWithLoginSuccessBlock:(void (^)())loginSuccessBlock;

/**
 *  Presents the login controller with a block of code to be executed after a successfull login and a block of code to be executed during the dismiss animation.
 *
 *  @param loginSuccessBlock The block code that will be executed after a successfull login.
 *  @param dismissBlock The block of code to be executed during the dismiss animation.
 */
- (void)presentLoginWithLoginSuccessBlock:(void (^)())loginSuccessBlock dismissBlock:(void (^)())dismissBlock;

/**
 *  Presents the login controller.
 *
 *  @param completionBlock The block code that will be executed after the presentation.
 *  @param loginSuccessBlock The block code that will be executed after a successfull login.
 *  @param dismissBlock Indicates if the dynamic home should be reloaded after a successfull login.
 */
- (void)presentLoginWithCompletionBlock:(void (^)())completionBlock successBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock;


- (void)presentLoginLinkFacebookWithSnId:(NSString *) snId facebookLink:(BOOL) isFacebookLink fromClass:(NSString *) prevClass completionBlock:(void (^)())completionBlock successBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock;

@end
