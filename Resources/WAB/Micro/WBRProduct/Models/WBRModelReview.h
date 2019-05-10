//
//  WBRModelReviews.h
//  Walmart
//
//  Created by Cássio Sousa on 03/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRModelReviewClient.h"

@protocol WBRModelReview
@end

@interface WBRModelReview : JSONModel

@property (strong, nonatomic) NSNumber *reviewId;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) WBRModelReviewClient<Optional> *client;
@property (strong, nonatomic) NSNumber *rating;
@property (copy, nonatomic) NSString<Optional> *title;
@property (copy, nonatomic) NSString<Optional> *text;
@property (assign, nonatomic) BOOL *showEmail;
@property (nonatomic, strong) NSNumber<Optional> *reviewDate;
@property (strong, nonatomic) NSNumber *voteCount;
@property (strong, nonatomic) NSNumber<Optional> *voteRelevant;

@end
