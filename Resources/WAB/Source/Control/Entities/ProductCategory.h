//
//  ProductCategory.h
//  Walmart
//
//  Created by Bruno Delgado on 6/3/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol ProductCategory
@end

@interface ProductCategory : JSONModel

@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, strong) NSString *name;

@end
