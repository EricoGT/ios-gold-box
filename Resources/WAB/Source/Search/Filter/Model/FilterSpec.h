//
//  FilterSpec.h
//  Walmart
//
//  Created by Danilo on 9/26/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//
#import "JSONModel.h"
#import "FilterSpecValue.h"
@protocol FilterSpec
@end

@interface FilterSpec : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*countValues;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber<Optional> *order;
@property (nonatomic, strong) NSArray <FilterSpecValue> *values;
@property (nonatomic, strong) NSNumber<Ignore> *isParent;

@end
