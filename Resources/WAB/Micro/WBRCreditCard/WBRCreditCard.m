//
//  WBRCreditCard.m
//  Walmart
//
//  Created by Rafael Valim on 27/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRCreditCard.h"

@implementation WBRCreditCard

- (void)requestUserWalletWithSuccess:(void (^)(WBRModelWallet *userWallet))success andFailure:(void (^)(NSError *error, NSData *data))failure {
    
    [[WBRCreditCardConnection new] requestUserWalletWithSuccess:^(WBRModelWallet *userWallet) {
        success(userWallet);
    } andFailure:^(NSError *error, NSData *data) {
        failure(error, data);
    }];
}

- (void)addUserCreditCard:(WBRModelCreditCard *)creditCard
              withSuccess:(void (^)(NSData *data))success
               andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    [[WBRCreditCardConnection new] addUserCreditCard:creditCard withSuccess:^(NSData *data) {
        success(data);
    } andFailure:^(NSError *error, NSData *dataError) {
        failure(error, dataError);
    }];
    
}

- (void)deleteUserCreditCard:(WBRModelCreditCard *)creditCard
                 withSuccess:(void (^)(NSData *data))success
                  andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    [[WBRCreditCardConnection new] deleteUserCreditCard:creditCard withSuccess:^(NSData *data) {
        success(data);
    } andFailure:^(NSError *error, NSData *dataError) {
        failure(error, dataError);
    }];
    
}

- (void)setDefaultUserCreditCard:(WBRModelCreditCard *)creditCard
                     withSuccess:(void (^)(NSData *data))success
                      andFailure:(void (^)(NSError *error, NSData *dataError))failure {
    
    [[WBRCreditCardConnection new] setDefaultUserCreditCard:creditCard withSuccess:^(NSData *data) {
        success(data);
    } andFailure:^(NSError *error, NSData *dataError) {
        failure(error, dataError);
    }];
    
}

@end
