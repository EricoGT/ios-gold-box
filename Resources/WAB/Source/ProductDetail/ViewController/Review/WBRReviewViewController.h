//
//  WBRReviewViewController.h
//  Walmart
//
//  Created by Cássio Sousa on 05/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRRatingModel.h"
#import "WBRReviewsModel.h"

@interface WBRReviewViewController : WMBaseViewController
-(WBRReviewViewController *)initWithProductId:(NSString *)productId ratingModel:(WBRRatingModel *)ratingModel;
-(WBRReviewViewController *)initWithReviews:(WBRReviewsModel*)reviewsModel ratingModel:(WBRRatingModel *)ratingModel productId:(NSString *)productId;
@end
