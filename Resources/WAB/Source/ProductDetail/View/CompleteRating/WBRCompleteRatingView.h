//
//  WBRCompleteRatingView.h
//  Walmart
//
//  Created by Guilherme Ferreira on 29/06/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBRRatingModel.h"

@protocol WBRCompleteRatingViewDelegate <NSObject>
@optional
- (void)navigateToReview;
@end

@interface WBRCompleteRatingView : UIView

@property (strong, nonatomic) WBRRatingModel *rating;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (nonatomic) BOOL onlyRatingScore;
@property (nonatomic) BOOL isRatingActionEnabled;

@property (nonatomic, weak) id <WBRCompleteRatingViewDelegate> delegate;

@end
