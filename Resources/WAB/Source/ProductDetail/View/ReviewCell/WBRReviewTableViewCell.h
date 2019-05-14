//
//  WBRReviewTableViewCell.h
//  Walmart
//
//  Created by Cássio Sousa on 06/10/2017.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRReviewModel.h"
@protocol WBRReviewTableViewCellDelegate <NSObject>
@optional
- (void)updateReviewCell:(NSNumber *)index;
- (void)reviewTableViewCellDidEvaluateReview:(NSIndexPath *)indexPath withEvaluation:(BOOL)evaluation;
@end

@interface WBRReviewTableViewCell : UITableViewCell
@property (nonatomic, weak) id <WBRReviewTableViewCellDelegate> delegate;

/**
 Setup cell with given review model

 @param reviewModel reference to populate cell
 @param linesShow number of lines to show of the review text
 */
- (void)setupReview:(WBRReviewModel *)reviewModel linesShow:(NSNumber *)linesShow forIndexPath:(NSIndexPath *)currentIndexPath;

/**
 Switch the cell state to ShowLessButton state
 */
- (void)showLessButton;

/**
 Switch the cell state to ShowMoreButton state
 */
- (void)showMoreButton;

/**
 Collapse or show the review evaluation view

 @param show wheter hide or not
 */
- (void)showReviewEvaluationView:(BOOL)show;


/**
 Method used to reset evaluation view state, so user can evaluate the review again
 */
- (void)resetEvaluationView;

@end
