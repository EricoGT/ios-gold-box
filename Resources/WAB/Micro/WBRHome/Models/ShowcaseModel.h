//
//  ShowcaseModel.h
//  Walmart
//
//  Created by Renan Cargnin on 8/17/15.
//  Copyright (c) 2015 Walmart.com. All rights reserved.
//

#import "JSONModel.h"

#import "ShowcaseProductModel.h"

@protocol ShowcaseModel
@end

@interface ShowcaseModel : JSONModel

@property (strong, nonatomic) NSString *showcaseId;
@property (strong, nonatomic) NSNumber *orderId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString<Optional> *type;
@property (strong, nonatomic) NSArray<ShowcaseProductModel> *products;
@property (assign, nonatomic) BOOL isRefreshing;
@property (assign, nonatomic) BOOL dynamic;

@end
