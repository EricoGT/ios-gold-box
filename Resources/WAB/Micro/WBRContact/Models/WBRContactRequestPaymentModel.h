//
//  WBRContactRequestPaymentModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

typedef enum {
    kExchangePaymentTypeBankSlip,
    kExchangePaymentTypeCreditCard
} kExchangePaymentType;

@protocol WBRContactRequestPaymentModel;

@interface WBRContactRequestPaymentModel : JSONModel

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString<Optional> *completeName;
@property (strong, nonatomic) NSString<Optional> *brand;
@property (strong, nonatomic) NSString<Optional> *lastDigitsOfCard;
@property (strong, nonatomic) NSString<Optional> *paymentUrl;

- (kExchangePaymentType)paymentType;

@end
