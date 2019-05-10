//
//  ModelDepartmentsSubcategories.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelDepartmentsSubcategories
@end

@interface ModelDepartmentsSubcategories : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *url;

@end
