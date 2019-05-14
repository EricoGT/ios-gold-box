//
//  WBRContactRequestCustomerModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 3/19/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol WBRContactRequestCustomerModel;

@interface WBRContactRequestCustomerModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *document;

@end
