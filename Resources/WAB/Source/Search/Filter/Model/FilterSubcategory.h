//
//  FilterSubcategory.h
//  Walmart
//
//  Created by Bruno Delgado on 9/15/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterSubcategory
@end

@interface FilterSubcategory : JSONModel

//@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSNumber *count;
//@property (nonatomic, strong) NSString <Optional> *filterValue;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber<Ignore> *isParent;
@property (assign, nonatomic) BOOL selected;
//@property (nonatomic, strong) NSNumber *countSubCategories;

@end
