//
//  FilterSpecValue.h
//  Walmart
//
//  Created by Danilo on 9/30/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterSpecValue <NSObject>

@end

@interface FilterSpecValue : JSONModel
@property(nonatomic, strong) NSNumber *count;
//@property(nonatomic, strong) NSString *filterValue;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber<Optional> *order;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSNumber<Ignore> *isParent;
@end
