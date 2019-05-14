//
//  WBRModelReviews.h
//  Walmart
//
//  Created by Cássio Sousa on 03/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//
#import "JSONModel.h"
#import "WBRModelReviews.h"
#import "WBRModelReview.h"

@interface WBRModelReviews: JSONModel

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *countPage;
@property (strong, nonatomic) NSArray <Optional, WBRModelReview> *results;
@property (strong, nonatomic) NSNumber *productId;

@end
