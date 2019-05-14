//
//  ModelDepartments.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelDepartmentsCategories.h"

@protocol ModelDepartments
@end

@interface ModelDepartments : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *filterValue;
@property (strong, nonatomic) NSNumber *selected;
@property (strong, nonatomic) NSArray <Optional, ModelDepartmentsCategories> *categories;

@end
