//
//  ModelWallet.m
//  Walmart
//
//  Created by Rafael Valim on 30/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WBRModelWallet.h"

@implementation WBRModelWallet


- (WBRModelCreditCard *)getMainCard {
    for (WBRModelCreditCard *creditCard in self.creditCards) {
        if (creditCard.flagDefault) {
            return creditCard;
            break;
        }
    }
    return nil;
}

- (BOOL)allCardsIsExpired {
    int expiredsCount = 0;
    for (WBRModelCreditCard *creditCard in self.creditCards) {
        if (creditCard.expired) {
            expiredsCount += 1;
        }
    }
    return expiredsCount == self.creditCards.count ? YES : NO;
}

@end
