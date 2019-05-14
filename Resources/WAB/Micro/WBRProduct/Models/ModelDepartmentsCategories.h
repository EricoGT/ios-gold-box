//
//  ModelDepartmentsCategories.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelDepartmentsSubcategories.h"

@protocol ModelDepartmentsCategories
@end

@interface ModelDepartmentsCategories : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *selected;
@property (strong, nonatomic) NSNumber *countSubCategories;
@property (strong, nonatomic) NSArray <Optional, ModelDepartmentsSubcategories> *subCategories;

@end
