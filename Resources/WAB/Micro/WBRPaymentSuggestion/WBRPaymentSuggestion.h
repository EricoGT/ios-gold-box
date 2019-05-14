//
//  WBRPaymentSuggestion.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 11/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRPaymentSuggestion : JSONModel

@property (strong, nonatomic) NSString *paymentMethod;
@property (strong, nonatomic) NSString<Ignore> *paymentMethodString;
@property (strong, nonatomic) NSNumber *currentPrice;
@property (strong, nonatomic) NSNumber *discountedPrice;

- (BOOL)isBankSlip;

@end
