//
//  Filter.h
//  Walmart
//
//  Created by Bruno Delgado on 9/12/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"
#import "FilterDepartment.h"
#import "FilterSpec.h"
#import "FilterSpecValue.h"

@protocol Filter
@end

@interface Filter : JSONModel

@property (nonatomic, strong) NSArray<FilterDepartment, Optional> *departments;
@property (nonatomic, strong) NSArray<FilterSpec, Optional> *specs;
@property (nonatomic, strong) NSArray<FilterSpecValue, Optional> *pricesRange;
@property (nonatomic, strong) NSArray<FilterSpecValue, Optional> *brands;

@end
