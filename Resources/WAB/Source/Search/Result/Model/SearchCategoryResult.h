//
//  SearchCategoryResult.h
//  Walmart
//
//  Created by Bruno Delgado on 7/11/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "SearchCategory.h"
#import "Filter.h"

#import "SearchProduct.h"

@interface SearchCategoryResult : JSONModel

@property (nonatomic, strong) Filter<Optional> *filters;
@property (nonatomic, strong) NSArray<SearchProduct,Optional> *products;
@property (nonatomic, strong) NSNumber <Optional>*count;

@end
