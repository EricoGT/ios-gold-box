//
//  WMSubcategoriesViewController.h
//  Walmart
//
//  Created by Bruno Delgado on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DepartmentMenuItem, CategoryMenuItem;

@interface WMSubcategoriesViewController : UIViewController

@property (strong, nonatomic) DepartmentMenuItem *department;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *counts;
@property (nonatomic, strong) CategoryMenuItem *seeAllItem;
@property (nonatomic, assign) BOOL hideIcon;
@property (nonatomic, assign) BOOL isThirdLevel;

- (WMSubcategoriesViewController *)initWithDepartment:(DepartmentMenuItem *)department;
- (WMSubcategoriesViewController *)initWithCategory:(CategoryMenuItem *)category department:(DepartmentMenuItem *)deparment;

@end
