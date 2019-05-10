//
//  UIViewController+Login.m
//  Walmart
//
//  Created by Renan Cargnin on 2/11/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//


#import "UIViewController+Login.h"
#import "WMBaseNavigationController.h"
#import "OFLoginViewController.h"
#import "WALHomeViewController.h"
#import "WBRLoginManager.h"
#import "User.h"
#import "PushHandler.h"
#import "WALTouchIDManager.h"
#import "NSString+Validation.h"
#import "FXKeychain.h"

@interface UIViewController ()

@end

@implementation UIViewController (Login)

#pragma mark - Login Screen
- (void)presentLoginControllerWithCompletionBlock:(void (^)())completionBlock successBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock {
    
    LogInfo(@"From Class: %@", NSStringFromClass([self class]));
    
    OFLoginViewController *loginViewController = [[OFLoginViewController alloc] initWithLoginSuccessBlock:successBlock];
    loginViewController.dismissBlock = dismissBlock;
    loginViewController.strScreen = NSStringFromClass([self class]);
    
    WMBaseNavigationController *loginContainer = [[WMBaseNavigationController alloc] initWithRootViewController:loginViewController];
    UIViewController *controller = self.navigationController ?: self;
    [controller presentViewController:loginContainer animated:YES completion:completionBlock];
}

- (void)presentLoginWithCompletionBlock:(void (^)())completionBlock successBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([WALTouchIDManager canUseTouchID]) {
            [self touchIDLoginSuccessBlock:successBlock dismissBlock:dismissBlock];
            if (completionBlock) completionBlock();
        }
        else {
            [self presentLoginControllerWithCompletionBlock:completionBlock successBlock:successBlock dismissBlock:dismissBlock];
        }
    });
}

- (void)presentLoginLinkFacebookWithSnId:(NSString *) snId facebookLink:(BOOL) isFacebookLink fromClass:(NSString *) prevClass completionBlock:(void (^)())completionBlock successBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        OFLoginViewController *loginViewController = [[OFLoginViewController alloc] initWithLoginSuccessBlock:successBlock];
        loginViewController.isFacebook = YES;
        loginViewController.dismissBlock = dismissBlock;
        loginViewController.isFacebookWithLink = isFacebookLink;
        loginViewController.strSnId = snId;
        loginViewController.strScreen = prevClass;
        
        WMBaseNavigationController *loginContainer = [[WMBaseNavigationController alloc] initWithRootViewController:loginViewController];
        UIViewController *controller = self.navigationController ?: self;
        [controller presentViewController:loginContainer animated:YES completion:completionBlock];
    });
}

- (void)presentLoginWithLoginSuccessBlock:(void (^)())loginSuccessBlock dismissBlock:(void (^)())dismissBlock {
    [self presentLoginWithCompletionBlock:nil successBlock:loginSuccessBlock dismissBlock:dismissBlock];
}

- (void)presentLoginWithLoginSuccessBlock:(void (^)())loginSuccessBlock {
    [self presentLoginWithLoginSuccessBlock:loginSuccessBlock dismissBlock:nil];
}

#pragma mark - Touch ID
- (void)touchIDLoginSuccessBlock:(void (^)())successBlock dismissBlock:(void (^)())dismissBlock {
    [WALTouchIDManager authenticateWithCompletionBlock:^(BOOL success) {
        if (success)
        {
            FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
            NSData *passData = [keychainItem objectForKey:kPassKeychainKey];
            NSString *login = [keychainItem objectForKey:kUserKeychainKey];
            NSString *secretKey = [[NSString alloc] initWithData:passData encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.view showModalLoading];
            });
            
            if ([login isEmail]) {
                
                if (login.length > 0 && secretKey.length > 0) {
                    [WBRLoginManager loginWithUser:login pass:secretKey isFacebook:nil isFacebookWithLink:nil snId:nil successBlock:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController.view hideModalLoading];
                        });
                        if (successBlock) {
                            successBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController.view hideModalLoading];
                        });
                        LogInfo(@"Falha ao realizar login com o TouchID (%@). Utilizando o fallback para tela de login", error.localizedDescription);
                        [self presentLoginControllerWithCompletionBlock:nil successBlock:successBlock dismissBlock:dismissBlock];
                    }];
                } else {
                    //Credentials are empty!
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController.view hideModalLoading];
                    });
                    LogInfo(@"Email: Falha ao realizar login com o TouchID (credentials are empty). Utilizando o fallback para tela de login");
                    [self presentLoginControllerWithCompletionBlock:nil successBlock:successBlock dismissBlock:dismissBlock];
                }
            } else {
                if (login.length > 0 && secretKey.length > 0) {
                    
                    [WBRLoginManager loginWithDocument:login pass:secretKey isFacebook:nil isFacebookWithLink:nil snId:nil successBlock:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController.view hideModalLoading];
                        });
                        if (successBlock) {
                            successBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController.view hideModalLoading];
                        });
                        LogInfo(@"Falha ao realizar login com o TouchID (%@). Utilizando o fallback para tela de login", error.localizedDescription);
                        [self presentLoginControllerWithCompletionBlock:nil successBlock:successBlock dismissBlock:dismissBlock];
                    }];
                } else {
                    //Credentials are empty!
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController.view hideModalLoading];
                    });
                    LogInfo(@"Document: Falha ao realizar login com o TouchID (credentials are empty). Utilizando o fallback para tela de login");
                    [self presentLoginControllerWithCompletionBlock:nil successBlock:successBlock dismissBlock:dismissBlock];
                }
            }
        } else {
            [self presentLoginControllerWithCompletionBlock:nil successBlock:successBlock dismissBlock:dismissBlock];
        }
    }];
}

@end
