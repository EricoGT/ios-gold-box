//
//  SearchDepartment.h
//  Walmart
//
//  Created by Bruno Delgado on 9/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "FilterCategory.h"
#import "FilterSubcategory.h"

@protocol FilterDepartment
@end

@interface FilterDepartment : JSONModel

@property (nonatomic, strong) NSString<Optional> *categoryId;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *count;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *filterValue;
@property (nonatomic, strong) NSNumber<Optional> *order;
@property (nonatomic, strong) NSNumber<Optional> *countCategories;
@property (nonatomic, strong) NSArray<FilterCategory,Optional> *categories;
@property (assign, nonatomic) BOOL selected;

@end
