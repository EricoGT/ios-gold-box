//
//  WBRContactRequestOrdersArrayModel.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 4/16/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

#import "WBRContactRequestOrderModel.h"

@interface WBRContactRequestOrdersArrayModel : JSONModel

@property (strong, nonatomic) NSArray<WBRContactRequestOrderModel> *orders;

@end
