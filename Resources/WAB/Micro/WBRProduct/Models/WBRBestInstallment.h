//
//  WBRBestCalculatedInstallment.h
//  Walmart
//
//  Created by Diego Batista Dias Leite on 20/07/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@interface WBRBestInstallment : JSONModel

@property (strong, nonatomic) NSNumber *installmentAmount;
@property (strong, nonatomic) NSArray<NSString *> *paymentTypes;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (strong, nonatomic) NSNumber<Optional> *valuePerInstallment;
@property (strong, nonatomic) NSString<Optional> *formattedPrice;
@property (strong, nonatomic) NSString<Optional> *formattedValuePerInstallment;
@property (strong, nonatomic) NSString<Optional> *currency;

@end
