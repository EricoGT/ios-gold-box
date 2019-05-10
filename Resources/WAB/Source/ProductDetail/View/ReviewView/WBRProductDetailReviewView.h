//
//  WBRProductDetailReviewView.h
//  Walmart
//
//  Created by Cássio Sousa on 06/11/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import "WMView.h"
#import "WBRRatingModel.h"
#import "WBRReviewModel.h"

@protocol WBRProductDetailReviewViewDelegate <NSObject>
- (void)showMoreReviews;

@optional
- (void)productDetailReviewCellDidEvaluateReviewIndexPath:(NSIndexPath *)reviewIndexPath withEvaluation:(BOOL)evaluation;
@end

@interface WBRProductDetailReviewView : WMView
@property (nonatomic, weak) id <WBRProductDetailReviewViewDelegate> delegate;
- (void)setupReview:(WBRRatingModel*) ratingModel reviewModelArray:(NSArray<WBRReviewModel *> *)reviewModelArray;
@end
