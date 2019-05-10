//
//  ModelProductFull.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelProducts.h"
#import "ModelFilters.h"

@interface ModelProductFull : JSONModel

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSArray <Optional, ModelProducts> *products;
@property (strong, nonatomic) ModelFilters <Optional> *filters;

@end
