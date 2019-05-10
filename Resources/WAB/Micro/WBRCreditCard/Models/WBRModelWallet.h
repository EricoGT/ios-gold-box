//
//  ModelWallet.h
//  Walmart
//
//  Created by Rafael Valim on 30/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRModelCreditCard.h"

@interface WBRModelWallet : JSONModel

@property (assign, nonatomic) NSInteger maxCards;
@property (assign, nonatomic) NSInteger totalCards;
@property (strong, nonatomic) NSArray<WBRModelCreditCard> *creditCards;

- (WBRModelCreditCard *)getMainCard;
- (BOOL)allCardsIsExpired;

@end
