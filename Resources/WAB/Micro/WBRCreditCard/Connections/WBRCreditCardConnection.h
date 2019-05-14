//
//  WBRCreditCardConnection.h
//  Walmart
//
//  Created by Rafael Valim on 27/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBRModelWallet.h"

@interface WBRCreditCardConnection : NSObject

/**
 Adds the given credit card to the user Wallet
 
 @param WBRModelCreditCard to be inserted
 @param success NSData
 @param failure NSError and NSData
 */
- (void)addUserCreditCard:(WBRModelCreditCard *)creditCard
              withSuccess:(void (^)(NSData *data))success
               andFailure:(void (^)(NSError *error, NSData *dataError))failure;

/**
 Deletes the given credit card from the user Wallet
 
 @param WBRModelCreditCard to be deleted
 @param success NSData
 @param failure NSError and NSData
 */
- (void)deleteUserCreditCard:(WBRModelCreditCard *)creditCard
                 withSuccess:(void (^)(NSData *data))success
                  andFailure:(void (^)(NSError *error, NSData *dataError))failure;

/**
 Retrieves the Wallet object associated with the currently logged in user
 The method uses the user token to retrieve the Wallet
 
 @param success WBRModelWallet
 @param failure NSError and NSData
 */
- (void)requestUserWalletWithSuccess:(void (^)(WBRModelWallet *userWallet))success
                          andFailure:(void (^)(NSError *error, NSData *data))failure;

/**
 Sets the given credit card as the account's default credit card
 
 @param WBRModelCreditCard to be set default
 @param success NSData
 @param failure NSError and NSData
 */
- (void)setDefaultUserCreditCard:(WBRModelCreditCard *)creditCard
                     withSuccess:(void (^)(NSData *data))success
                      andFailure:(void (^)(NSError *error, NSData *dataError))failure;
@end
