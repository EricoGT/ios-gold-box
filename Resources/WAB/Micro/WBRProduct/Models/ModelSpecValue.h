//
//  ModelSpecValue.h
//  Walmart
//
//  Created by Marcelo Santos on 3/28/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"

@protocol ModelSpecValue
@end

@interface ModelSpecValue : JSONModel

@property (strong, nonatomic) NSString<Optional> *brandId;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *filterValue;
@property (strong, nonatomic) NSString *name;
@property (nonatomic, strong) NSNumber<Optional> *order;
@property (strong, nonatomic) NSNumber *selected;
@property (strong, nonatomic) NSString *url;
@property (nonatomic, strong) NSNumber<Ignore> *isParent;

@end
