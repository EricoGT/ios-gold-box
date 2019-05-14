//
//  FilterCategory.h
//  Walmart
//
//  Created by Bruno Delgado on 9/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "FilterSubcategory.h"

@protocol FilterCategory
@end

@interface FilterCategory : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *categoryId;
@property (nonatomic, strong) NSNumber<Optional> *count;
@property (nonatomic, strong) NSNumber<Optional> *countSubCategories;
@property (nonatomic, strong) NSString<Optional> *filterValue;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *order;
@property (nonatomic, strong) NSArray<FilterSubcategory, Optional> *subCategories;
@property (nonatomic, strong) NSString<Optional> *url;
@property (assign, nonatomic) BOOL selected;

@end
