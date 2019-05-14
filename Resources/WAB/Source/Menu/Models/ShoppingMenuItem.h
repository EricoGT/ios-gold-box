//
//  ShoppingMenuItem.h
//  Walmart
//
//  Created by Bruno Delgado on 11/27/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "DepartmentMenuItem.h"

@interface ShoppingMenuItem : JSONModel

@property (nonatomic, strong) NSString<Optional> *header;
@property (nonatomic, strong) NSArray<Optional> *color;
@property (nonatomic, strong) NSArray<DepartmentMenuItem,Optional> *departments;

@end
