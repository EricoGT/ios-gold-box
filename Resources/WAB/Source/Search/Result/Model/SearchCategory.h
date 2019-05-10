//
//  SearchCategory.h
//  Walmart
//
//  Created by Bruno Delgado on 7/7/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "SearchProduct.h"

@protocol SearchCategory
@end

@interface SearchCategory : JSONModel

@property (nonatomic, strong) NSString<Optional> *collectionId;
@property (nonatomic, strong) NSString<Optional> *categoryName;
@property (nonatomic, strong) NSNumber<Optional> *totalProducts;
@property (nonatomic, strong) NSNumber<Optional> *resultGrouped;
//@property (nonatomic, strong) NSArray<SearchProduct> *products;
@property (nonatomic, strong) NSNumber<Ignore> *currentPage;

@end
