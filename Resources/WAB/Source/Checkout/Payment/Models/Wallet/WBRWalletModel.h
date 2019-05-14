//
//  WBRWalletModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

#import "WBRCardModel.h"

@interface WBRWalletModel : JSONModel

@property (strong, nonatomic) NSString *customerId;
@property (strong, nonatomic) NSNumber *maxCards;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSArray<WBRCardModel> *cards;

@end
