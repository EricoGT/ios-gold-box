//
//  ModelSpec.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "ModelSpecValue.h"

@protocol ModelSpec
@end

@interface ModelSpec : JSONModel

@property (nonatomic, strong) NSNumber *countValues;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber<Optional> *order;
@property (nonatomic, strong) NSArray <ModelSpecValue> *values;
@property (nonatomic, strong) NSNumber<Ignore> *isParent;

@end
