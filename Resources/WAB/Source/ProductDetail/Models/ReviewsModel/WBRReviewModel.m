//
//  WBRReviewModel.m
//  Walmart
//
//  Created by Cássio Sousa on 04/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//
#import "WBRReviewModel.h"

@implementation WBRReviewModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"reviewId" : @"reviewId",
                                                                  @"productId" : @"productId",
                                                                  @"client" : @"client",
                                                                  @"rating" : @"rating",
                                                                  @"title" : @"title",
                                                                  @"text" : @"text",
                                                                  @"reviewDate" : @"reviewDate",
                                                                  @"voteCount" : @"voteCount",
                                                                  @"voteRelevant" : @"voteRelevant"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"reviewEvaluated"]) {
        return YES;
    }
    
    return NO;
}

@end
