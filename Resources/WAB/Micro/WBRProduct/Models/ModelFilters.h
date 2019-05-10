//
//  ModelFilters.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelDepartments.h"
#import "ModelSpecValue.h"
#import "ModelSpec.h"

@interface ModelFilters : JSONModel

@property (strong, nonatomic) NSArray <Optional, ModelDepartments> *departments;
@property (strong, nonatomic) NSArray <Optional, ModelSpecValue> *brands;
@property (strong, nonatomic) NSArray <Optional, ModelSpecValue> *pricesRange;
@property (strong, nonatomic) NSArray <Optional, ModelSpec> *specs;

@end
