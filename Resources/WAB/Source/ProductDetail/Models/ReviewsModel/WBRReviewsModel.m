//
//  WBRReviewsModel.m
//  Walmart
//
//  Created by Cássio Sousa on 04/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//
#import "WBRReviewsModel.h"

@implementation WBRReviewsModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"count" : @"count",
                                                       @"pageSize" : @"pageSize",
                                                       @"countPage" : @"countPage",
                                                       @"results" : @"results",
                                                       @"productId" : @"productId"}];
}

@end
