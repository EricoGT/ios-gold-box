//
//  CategoryMenuItem.h
//  Walmart
//
//  Created by Bruno Delgado on 2/6/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "JSONModel.h"

@protocol CategoryMenuItem
@end

@interface CategoryMenuItem : JSONModel

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray<CategoryMenuItem> *children;

@property (nonatomic, strong) NSString<Optional> *imageSelected;
@property (nonatomic, strong) NSNumber<Optional> *useHub;
@property (nonatomic, strong) NSNumber<Ignore> *isSeeAll;

@end
