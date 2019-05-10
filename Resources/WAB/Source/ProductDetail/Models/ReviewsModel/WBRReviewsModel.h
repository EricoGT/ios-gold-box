//
//  WBRReviewsModel.h
//  Walmart
//
//  Created by Cássio Sousa on 04/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//
#import "JSONModel.h"
#import "WBRReviewsModel.h"
#import "WBRReviewModel.h"

@interface WBRReviewsModel: JSONModel

@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *countPage;
@property (strong, nonatomic) NSArray <Optional, WBRReviewModel> *results;
@property (strong, nonatomic) NSNumber *productId;

@end
