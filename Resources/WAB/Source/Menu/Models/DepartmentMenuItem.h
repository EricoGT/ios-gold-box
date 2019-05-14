//
//  DepartmentMenuItem.h
//  Walmart
//
//  Created by Bruno Delgado on 11/24/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "CategoryMenuItem.h"

@protocol DepartmentMenuItem
@end

@interface DepartmentMenuItem : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *departmentId;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSNumber<Optional> *useHub;
@property (nonatomic, strong) NSString<Optional> *image;
@property (nonatomic, strong) NSString<Optional> *imageSelected;
@property (nonatomic, strong) NSString<Ignore> *imageName;
@property (nonatomic, assign) NSNumber<Ignore> *isAllDepartments;

@end
