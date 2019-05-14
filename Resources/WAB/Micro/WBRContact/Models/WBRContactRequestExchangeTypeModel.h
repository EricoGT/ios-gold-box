//
//  WBRContactRequestExchangeTypeModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRContactRequestExchangeTypeModelLabel.h"

@protocol WBRContactRequestExchangeTypeModel
@end

@interface WBRContactRequestExchangeTypeModel : JSONModel

@property (strong, nonatomic) NSString *exchangeLabel;
@property (strong, nonatomic) NSString *exchangeType;
@property (strong, nonatomic) NSArray<WBRContactRequestExchangeTypeModelLabel> *values;

@end
