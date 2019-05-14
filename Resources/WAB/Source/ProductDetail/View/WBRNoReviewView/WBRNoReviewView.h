//
//  WBRNoReviewView.h
//  Walmart
//
//  Created by Guilherme Nunes Ferreira on 7/31/18.
//  Copyright © 2018 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBRNoReviewView;

@protocol WBRNoViewViewDelegate

- (void)WBRNoReviewViewDidSelectEvaluateProduct;
    
@end

@interface WBRNoReviewView : UIView

@property (weak, nonatomic) id<WBRNoViewViewDelegate> delegate;

@end
