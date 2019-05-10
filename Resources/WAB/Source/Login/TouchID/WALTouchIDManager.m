//
//  WALTouchIDManager.m
//  Walmart
//
//  Created by Bruno Delgado on 2/25/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "WALTouchIDManager.h"
#import "FXKeychain.h"

@implementation WALTouchIDManager

+ (BOOL)canUseTouchID
{
    if (![OFSetup enableTouchID]) return NO;

    LAContext *context = [LAContext new];
    NSError *error;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
        NSData *passData = [keychainItem objectForKey:kPassKeychainKey];
        NSString *login = [keychainItem objectForKey:kUserKeychainKey];
        NSString *secretKey = [[NSString alloc] initWithData:passData encoding:NSUTF8StringEncoding];
        if (login.length > 0 && secretKey.length > 0)
        {
            return YES;
        }
        else
        {
            LogInfo(@"TouchID: Ainda não temos as credenciais salvas para efetuar o login com o TouchID");
            return NO;
        }
    }
    else
    {
        switch (error.code)
        {
            case LAErrorTouchIDNotEnrolled:
                LogInfo(@"TouchID desativado: Não configurado");
            case LAErrorPasscodeNotSet:
                LogInfo(@"TouchID desativado: Aparelho sem senha");
            default:
                LogInfo(@"TouchID desativado: Não disponível");
        }
        return NO;
    }
}

+ (void)authenticateWithCompletionBlock:(void (^)(BOOL success))completion;
{
    LAContext *context = [LAContext new];
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    NSString *reason = [OFMessages touchIdReasonMessage];
    
    [context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError * _Nullable error)
     {
         if (success)
         {
             LogInfo(@"TouchID: Autenticado com sucesso");
             if (completion) completion(YES);
         }
         else
         {
             switch (error.code) {
                 case LAErrorSystemCancel:
                     LogInfo(@"TouchID: Autenticação cancelada pelo sistema");
                     if (completion) completion(NO);
                     break;
                 case LAErrorUserCancel:
                     LogInfo(@"TouchID: Autenticação cancelada pelo usuário");
                     if (completion) completion(NO);
                     break;
                 case LAErrorUserFallback:
                     LogInfo(@"TouchID: Usuário escolher a opção de senha");
                     if (completion) completion(NO);
                     break;
                 default:
                     LogInfo(@"TouchID: Falha na autenticação");
                     if (completion) completion(NO);
                     break;
             }
         }
     }];
}

+ (void)storeUser:(NSString *)user password:(NSString *)password
{
    NSData *pwdData = [password dataUsingEncoding:NSUTF8StringEncoding];
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    [keychainItem setObject:user forKey:kUserKeychainKey];
    [keychainItem setObject:pwdData forKey:kPassKeychainKey];
}

+ (void)updatePassword:(NSString *)newPassword
{
    NSData *pwdData = [newPassword dataUsingEncoding:NSUTF8StringEncoding];
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    [keychainItem setObject:pwdData forKey:kPassKeychainKey];
}

+ (void)cleanCredentials
{
    FXKeychain *keychainItem = [[FXKeychain alloc] initWithService:kKeychainService accessGroup:nil];
    [keychainItem setObject:nil forKey:kUserKeychainKey];
    [keychainItem setObject:[NSData new] forKey:kPassKeychainKey];
}


@end
