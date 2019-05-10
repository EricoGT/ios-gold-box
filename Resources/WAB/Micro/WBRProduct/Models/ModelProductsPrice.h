//
//  ModelProductsPrice.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelProductsPrice
@end

@interface ModelProductsPrice : JSONModel

@property (strong, nonatomic) NSNumber <Optional> *listPrice;
@property (strong, nonatomic) NSNumber *sellPrice;

@end
