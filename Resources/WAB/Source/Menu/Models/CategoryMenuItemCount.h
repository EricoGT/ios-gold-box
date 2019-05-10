//
//  CategoryMenuItemCount.h
//  Walmart
//
//  Created by Bruno Delgado on 2/9/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@interface CategoryMenuItemCount : JSONModel

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSNumber *total;

@end
