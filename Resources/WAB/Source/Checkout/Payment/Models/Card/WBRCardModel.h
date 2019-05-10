//
//  WBRCardModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 9/18/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRCardHolderModel.h"

@protocol WBRCardModel

@end

@interface WBRCardModel : JSONModel

@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) WBRCardHolderModel *holder;
@property (strong, nonatomic) NSString *fakeCardNumber;
//@property (strong, nonatomic) NSString *tokenPan;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *mask;
@property (strong, nonatomic) NSString *maskLast4;
@property (strong, nonatomic) NSString *last4;
@property (strong, nonatomic) NSString *expirationDate;
@property (nonatomic) BOOL expired;
@property (nonatomic) BOOL defaultCard;

@end
