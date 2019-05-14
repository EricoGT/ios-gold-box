//
//  WBRReviewModel.h
//  Walmart
//
//  Created by Cássio Sousa on 04/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "JSONModel.h"
#import "WBRReviewClientModel.h"

typedef enum : NSInteger {
    kReviewEvaluatedNoEvaluation,
    kReviewEvaluatedNegativeEvaluation,
    kReviewEvaluatedPositiveEvaluation
} kReviewEvaluated;

@protocol WBRReviewModel
@end

@interface WBRReviewModel : JSONModel

@property (strong, nonatomic) NSNumber *reviewId;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) WBRReviewClientModel<Optional> *client;
@property (strong, nonatomic) NSNumber *rating;
@property (copy, nonatomic) NSString<Optional> *title;
@property (copy, nonatomic) NSString<Optional> *text;
@property (strong, nonatomic) NSNumber *reviewDate;
@property (strong, nonatomic) NSNumber *voteCount;
@property (strong, nonatomic) NSNumber *voteRelevant;
@property (strong, nonatomic) NSString<Optional> *syndicationName;
@property (strong, nonatomic) NSString<Optional> *logoImageUrl;

@property (nonatomic) kReviewEvaluated reviewEvaluated;

@end

