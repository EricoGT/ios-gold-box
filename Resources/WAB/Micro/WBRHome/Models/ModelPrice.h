//
//  ModelPrice.h
//  Walmart
//
//  Created by Marcelo Santos on 3/23/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelPrice
@end

@interface ModelPrice : JSONModel

@property (strong, nonatomic) NSNumber <Optional> *listPrice;
@property (strong, nonatomic) NSNumber *sellPrice;

@end
