//
//  WBRProductDetailReviewCell.h
//  Walmart
//
//  Created by Cássio Sousa on 07/11/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRReviewModel.h"

@protocol WBRProductDetailReviewCellDelegate <NSObject>
- (void)productDetailReviewCellDidEvaluateReviewIndexPath:(NSIndexPath *)reviewIndexPath withEvaluation:(BOOL)evaluation;
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface WBRProductDetailReviewCell : UITableViewCell

@property (nonatomic, weak) id <WBRProductDetailReviewCellDelegate> delegate;

- (void)setupCell:(WBRReviewModel *)reviewModel forIndexPath:(NSIndexPath *)currentIndexPath;
- (void)hideSeparator;

/**
 Collapse or show the review evaluation view
 
 @param hide wheter hide or not
 */
- (void)showReviewEvaluationView:(BOOL)show;

@end
