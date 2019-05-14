//
//  ModelCreditCard.h
//  Walmart
//
//  Created by Rafael Valim on 27/10/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRModelCreditCard;

@interface WBRModelCreditCard : JSONModel

@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *completeName;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *lastDigitsOfCard;
@property (nonatomic, copy) NSString *maskDigits;
@property (nonatomic, copy) NSString *expirationDate;
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, assign) BOOL pending;
@property (nonatomic, copy) NSString<Optional> *paymentSystem;
@property (nonatomic, assign) BOOL hipercard;
@property (nonatomic, assign) BOOL flagDefault;

//Optional properties, used only when inserting a new card

@property (nonatomic, copy) NSString<Optional> *cardNumber;
@property (nonatomic, copy) NSString<Optional> *document;
@property (nonatomic, copy) NSString<Optional> *cvv2;
@property (nonatomic, copy) NSString<Optional> *expiryYear;
@property (nonatomic, copy) NSString<Optional> *expiryMonth;

@end
